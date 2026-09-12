/*
 * Copyright (c) 2012 Will Drewry <wad@dataspill.org>
 * Copyright (c) 2015,2017,2019,2020,2023 Damien Miller <djm@mindrot.org>
 * Copyright (c) 2025 Epic Games, Inc. All Rights Reserved.
 * Copyright (c) 2026 Filip Pizlo. All Rights Reserved.
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <unistd.h>
#include <sys/prctl.h>
#include <linux/seccomp.h>
#include <linux/filter.h>
#include <linux/audit.h>
#include <sys/syscall.h>
#include <errno.h>
#include <sys/stat.h>
#include <limits.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/mman.h>
#include <linux/futex.h>
#include <stdarg.h>
#include <string.h>
#include <inttypes.h>
#include <stdfil.h>
#include <sys/wait.h>

static void fatal(const char* msg, ...)
{
    va_list list;
    va_start(list, msg);
    vfprintf(stderr, msg, list);
    fflush(stderr);
    abort();
}

/* Simple seccomp test that blocks mkdir syscall */

/* Linux seccomp_filter sandbox */
#define SECCOMP_FILTER_FAIL SECCOMP_RET_KILL

/* Use a signal handler to emit violations when debugging */
#ifdef SANDBOX_SECCOMP_FILTER_DEBUG
# undef SECCOMP_FILTER_FAIL
# define SECCOMP_FILTER_FAIL SECCOMP_RET_TRAP
#endif /* SANDBOX_SECCOMP_FILTER_DEBUG */

#if __BYTE_ORDER == __LITTLE_ENDIAN
# define ARG_LO_OFFSET  0
# define ARG_HI_OFFSET  sizeof(uint32_t)
#elif __BYTE_ORDER == __BIG_ENDIAN
# define ARG_LO_OFFSET  sizeof(uint32_t)
# define ARG_HI_OFFSET  0
#else
#error "Unknown endianness"
#endif

/* Simple helpers to avoid manual errors (but larger BPF programs). */
#define SC_DENY(_nr, _errno) \
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, (_nr), 0, 1), \
	BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ERRNO|(_errno))
#define SC_ALLOW(_nr) \
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, (_nr), 0, 1), \
	BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW)
#define SC_ALLOW_ARG(_nr, _arg_nr, _arg_val) \
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, (_nr), 0, 6), \
	/* load and test syscall argument, low word */ \
	BPF_STMT(BPF_LD+BPF_W+BPF_ABS, \
	    offsetof(struct seccomp_data, args[(_arg_nr)]) + ARG_LO_OFFSET), \
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, \
	    ((_arg_val) & 0xFFFFFFFF), 0, 3), \
	/* load and test syscall argument, high word */ \
	BPF_STMT(BPF_LD+BPF_W+BPF_ABS, \
	    offsetof(struct seccomp_data, args[(_arg_nr)]) + ARG_HI_OFFSET), \
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, \
	    (((uint32_t)((uint64_t)(_arg_val) >> 32)) & 0xFFFFFFFF), 0, 1), \
	BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW), \
	/* reload syscall number; all rules expect it in accumulator */ \
	BPF_STMT(BPF_LD+BPF_W+BPF_ABS, \
		offsetof(struct seccomp_data, nr))
/* Allow if syscall argument contains only values in mask */
#define SC_ALLOW_ARG_MASK(_nr, _arg_nr, _arg_mask) \
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, (_nr), 0, 8), \
	/* load, mask and test syscall argument, low word */ \
	BPF_STMT(BPF_LD+BPF_W+BPF_ABS, \
	    offsetof(struct seccomp_data, args[(_arg_nr)]) + ARG_LO_OFFSET), \
	BPF_STMT(BPF_ALU+BPF_AND+BPF_K, ~((_arg_mask) & 0xFFFFFFFF)), \
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, 0, 0, 4), \
	/* load, mask and test syscall argument, high word */ \
	BPF_STMT(BPF_LD+BPF_W+BPF_ABS, \
	    offsetof(struct seccomp_data, args[(_arg_nr)]) + ARG_HI_OFFSET), \
	BPF_STMT(BPF_ALU+BPF_AND+BPF_K, \
	    ~(((uint32_t)((uint64_t)(_arg_mask) >> 32)) & 0xFFFFFFFF)), \
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, 0, 0, 1), \
	BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW), \
	/* reload syscall number; all rules expect it in accumulator */ \
	BPF_STMT(BPF_LD+BPF_W+BPF_ABS, \
		offsetof(struct seccomp_data, nr))
/* Deny unless syscall argument contains only values in mask */
#define SC_DENY_UNLESS_ARG_MASK(_nr, _arg_nr, _arg_mask, _errno) \
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, (_nr), 0, 8), \
	/* load, mask and test syscall argument, low word */ \
	BPF_STMT(BPF_LD+BPF_W+BPF_ABS, \
	    offsetof(struct seccomp_data, args[(_arg_nr)]) + ARG_LO_OFFSET), \
	BPF_STMT(BPF_ALU+BPF_AND+BPF_K, ~((_arg_mask) & 0xFFFFFFFF)), \
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, 0, 0, 3), \
	/* load, mask and test syscall argument, high word */ \
	BPF_STMT(BPF_LD+BPF_W+BPF_ABS, \
	    offsetof(struct seccomp_data, args[(_arg_nr)]) + ARG_HI_OFFSET), \
	BPF_STMT(BPF_ALU+BPF_AND+BPF_K, \
	    ~(((uint32_t)((uint64_t)(_arg_mask) >> 32)) & 0xFFFFFFFF)), \
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, 0, 1, 0), \
	BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ERRNO|(_errno)), \
	/* reload syscall number; all rules expect it in accumulator */ \
	BPF_STMT(BPF_LD+BPF_W+BPF_ABS, \
		offsetof(struct seccomp_data, nr))
#define SC_DENY_UNLESS_MASK(_nr, _arg_nr, _arg_val, _errno) \
/* Special handling for futex(2) that combines a bitmap and operation number */
#if defined(__NR_futex) || defined(__NR_futex_time64)
#define SC_FUTEX_MASK (FUTEX_PRIVATE_FLAG|FUTEX_CLOCK_REALTIME)
#define SC_ALLOW_FUTEX_OP(_nr, _op) \
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, (_nr), 0, 8), \
	/* load syscall argument, low word */ \
	BPF_STMT(BPF_LD+BPF_W+BPF_ABS, \
	    offsetof(struct seccomp_data, args[1]) + ARG_LO_OFFSET), \
	/* mask off allowed bitmap values, low word */ \
	BPF_STMT(BPF_ALU+BPF_AND+BPF_K, ~(SC_FUTEX_MASK & 0xFFFFFFFF)), \
	/* test operation number, low word */ \
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, ((_op) & 0xFFFFFFFF), 0, 4), \
	/* load syscall argument, high word */ \
	BPF_STMT(BPF_LD+BPF_W+BPF_ABS, \
	    offsetof(struct seccomp_data, args[1]) + ARG_HI_OFFSET), \
	/* mask off allowed bitmap values, high word */ \
	BPF_STMT(BPF_ALU+BPF_AND+BPF_K, \
	    ~(((uint32_t)((uint64_t)SC_FUTEX_MASK >> 32)) & 0xFFFFFFFF)), \
	/* test operation number, high word */ \
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, \
	    (((uint32_t)((uint64_t)(_op) >> 32)) & 0xFFFFFFFF), 0, 1), \
	BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW), \
	/* reload syscall number; all rules expect it in accumulator */ \
	BPF_STMT(BPF_LD+BPF_W+BPF_ABS, offsetof(struct seccomp_data, nr))

/* Use this for both __NR_futex and __NR_futex_time64 */
# define SC_FUTEX(_nr) \
	SC_ALLOW_FUTEX_OP(__NR_futex, FUTEX_WAIT), \
	SC_ALLOW_FUTEX_OP(__NR_futex, FUTEX_WAIT_BITSET), \
	SC_ALLOW_FUTEX_OP(__NR_futex, FUTEX_WAKE), \
	SC_ALLOW_FUTEX_OP(__NR_futex, FUTEX_WAKE_BITSET), \
	SC_ALLOW_FUTEX_OP(__NR_futex, FUTEX_REQUEUE), \
	SC_ALLOW_FUTEX_OP(__NR_futex, FUTEX_CMP_REQUEUE)
#endif /* __NR_futex || __NR_futex_time64 */

#if defined(__NR_mmap) || defined(__NR_mmap2)
# ifdef MAP_FIXED_NOREPLACE
#  define SC_MMAP_FLAGS MAP_PRIVATE|MAP_ANONYMOUS|MAP_FIXED|MAP_FIXED_NOREPLACE|MAP_NORESERVE
# else
#  define SC_MMAP_FLAGS MAP_PRIVATE|MAP_ANONYMOUS|MAP_FIXED|MAP_NORESERVE
# endif /* MAP_FIXED_NOREPLACE */
/* Use this for both __NR_mmap and __NR_mmap2 variants */
# define SC_MMAP(_nr) \
	SC_DENY_UNLESS_ARG_MASK(_nr, 3, SC_MMAP_FLAGS, EINVAL), \
	SC_ALLOW_ARG_MASK(_nr, 2, PROT_READ|PROT_WRITE|PROT_NONE)
#endif /* __NR_mmap || __NR_mmap2 */

/* Syscall filtering set for preauth. */
static const struct sock_filter preauth_insns[] = {
	/* Ensure the syscall arch convention is as expected. */
	BPF_STMT(BPF_LD+BPF_W+BPF_ABS,
		offsetof(struct seccomp_data, arch)),
#if defined(__x86_64__)
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, AUDIT_ARCH_X86_64, 1, 0),
#elif defined(__aarch64__)
	BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, AUDIT_ARCH_AARCH64, 1, 0),
#else
#error "Bad arch"
#endif
	BPF_STMT(BPF_RET+BPF_K, SECCOMP_FILTER_FAIL),
	/* Load the syscall number for checking. */
	BPF_STMT(BPF_LD+BPF_W+BPF_ABS,
		offsetof(struct seccomp_data, nr)),

	/* Syscalls to non-fatally deny */
#ifdef __NR_lstat
	SC_DENY(__NR_lstat, EACCES),
#endif
#ifdef __NR_lstat64
	SC_DENY(__NR_lstat64, EACCES),
#endif
#ifdef __NR_fstat
	SC_DENY(__NR_fstat, EACCES),
#endif
#ifdef __NR_fstat64
	SC_DENY(__NR_fstat64, EACCES),
#endif
#ifdef __NR_fstatat64
	SC_DENY(__NR_fstatat64, EACCES),
#endif
#ifdef __NR_open
	SC_DENY(__NR_open, EACCES),
#endif
#ifdef __NR_openat
	SC_DENY(__NR_openat, EACCES),
#endif
#ifdef __NR_newfstatat
	SC_DENY(__NR_newfstatat, EACCES),
#endif
#ifdef __NR_stat
	SC_DENY(__NR_stat, EACCES),
#endif
#ifdef __NR_stat64
	SC_DENY(__NR_stat64, EACCES),
#endif
#ifdef __NR_shmget
	SC_DENY(__NR_shmget, EACCES),
#endif
#ifdef __NR_shmat
	SC_DENY(__NR_shmat, EACCES),
#endif
#ifdef __NR_shmdt
	SC_DENY(__NR_shmdt, EACCES),
#endif
#ifdef __NR_ipc
	SC_DENY(__NR_ipc, EACCES),
#endif
#ifdef __NR_statx
	SC_DENY(__NR_statx, EACCES),
#endif

	/* Syscalls to permit */
#ifdef __NR_brk
	SC_ALLOW(__NR_brk),
#endif
#ifdef __NR_sched_yield
	SC_ALLOW(__NR_sched_yield),
#endif
#ifdef __NR_clock_gettime
	SC_ALLOW(__NR_clock_gettime),
#endif
#ifdef __NR_clock_gettime64
	SC_ALLOW(__NR_clock_gettime64),
#endif
#ifdef __NR_close
	SC_ALLOW(__NR_close),
#endif
#ifdef __NR_exit
	SC_ALLOW(__NR_exit),
#endif
#ifdef __NR_exit_group
	SC_ALLOW(__NR_exit_group),
#endif
#ifdef __NR_futex
	SC_FUTEX(__NR_futex),
#endif
#ifdef __NR_futex_time64
	SC_FUTEX(__NR_futex_time64),
#endif
#ifdef __NR_geteuid
	SC_ALLOW(__NR_geteuid),
#endif
#ifdef __NR_geteuid32
	SC_ALLOW(__NR_geteuid32),
#endif
#ifdef __NR_getpgid
	SC_ALLOW(__NR_getpgid),
#endif
#ifdef __NR_getpid
	SC_ALLOW(__NR_getpid),
#endif
#ifdef __NR_getrandom
	SC_ALLOW(__NR_getrandom),
#endif
#ifdef __NR_gettid
	SC_ALLOW(__NR_gettid),
#endif
#ifdef __NR_gettimeofday
	SC_ALLOW(__NR_gettimeofday),
#endif
#ifdef __NR_getuid
	SC_ALLOW(__NR_getuid),
#endif
#ifdef __NR_getuid32
	SC_ALLOW(__NR_getuid32),
#endif
#ifdef __NR_madvise
	SC_ALLOW_ARG(__NR_madvise, 2, MADV_NORMAL),
# ifdef MADV_FREE
	SC_ALLOW_ARG(__NR_madvise, 2, MADV_FREE),
# endif
# ifdef MADV_DONTNEED
	SC_ALLOW_ARG(__NR_madvise, 2, MADV_DONTNEED),
# endif
# ifdef MADV_DONTFORK
	SC_ALLOW_ARG(__NR_madvise, 2, MADV_DONTFORK),
# endif
# ifdef MADV_DONTDUMP
	SC_ALLOW_ARG(__NR_madvise, 2, MADV_DONTDUMP),
# endif
# ifdef MADV_WIPEONFORK
	SC_ALLOW_ARG(__NR_madvise, 2, MADV_WIPEONFORK),
# endif
	SC_DENY(__NR_madvise, EINVAL),
#endif
#ifdef __NR_mmap
	SC_MMAP(__NR_mmap),
#endif
#ifdef __NR_mmap2
	SC_MMAP(__NR_mmap2),
#endif
#ifdef __NR_mprotect
	SC_ALLOW_ARG_MASK(__NR_mprotect, 2, PROT_READ|PROT_WRITE|PROT_NONE),
#endif
#ifdef __NR_mremap
	SC_ALLOW(__NR_mremap),
#endif
#ifdef __NR_munmap
	SC_ALLOW(__NR_munmap),
#endif
#ifdef __NR_nanosleep
	SC_ALLOW(__NR_nanosleep),
#endif
#ifdef __NR_clock_nanosleep
	SC_ALLOW(__NR_clock_nanosleep),
#endif
#ifdef __NR_clock_nanosleep_time64
	SC_ALLOW(__NR_clock_nanosleep_time64),
#endif
#ifdef __NR_clock_gettime64
	SC_ALLOW(__NR_clock_gettime64),
#endif
#ifdef __NR__newselect
	SC_ALLOW(__NR__newselect),
#endif
#ifdef __NR_ppoll
	SC_ALLOW(__NR_ppoll),
#endif
#ifdef __NR_ppoll_time64
	SC_ALLOW(__NR_ppoll_time64),
#endif
#ifdef __NR_poll
	SC_ALLOW(__NR_poll),
#endif
#ifdef __NR_pselect6
	SC_ALLOW(__NR_pselect6),
#endif
#ifdef __NR_pselect6_time64
	SC_ALLOW(__NR_pselect6_time64),
#endif
#ifdef __NR_read
	SC_ALLOW(__NR_read),
#endif
#ifdef __NR_rt_sigprocmask
	SC_ALLOW(__NR_rt_sigprocmask),
#endif
#ifdef __NR_select
	SC_ALLOW(__NR_select),
#endif
#ifdef __NR_shutdown
	SC_ALLOW(__NR_shutdown),
#endif
#ifdef __NR_sigprocmask
	SC_ALLOW(__NR_sigprocmask),
#endif
#ifdef __NR_time
	SC_ALLOW(__NR_time),
#endif
#ifdef __NR_write
	SC_ALLOW(__NR_write),
#endif
#ifdef __NR_writev
	SC_ALLOW(__NR_writev),
#endif
#ifdef __NR_socketcall
	SC_ALLOW_ARG(__NR_socketcall, 0, SYS_SHUTDOWN),
	SC_DENY(__NR_socketcall, EACCES),
#endif
#if defined(__NR_ioctl) && defined(__s390__)
	/* Allow ioctls for ICA crypto card on s390 */
	SC_ALLOW_ARG(__NR_ioctl, 1, Z90STAT_STATUS_MASK),
	SC_ALLOW_ARG(__NR_ioctl, 1, ICARSAMODEXPO),
	SC_ALLOW_ARG(__NR_ioctl, 1, ICARSACRT),
	SC_ALLOW_ARG(__NR_ioctl, 1, ZSECSENDCPRB),
	/* Allow ioctls for EP11 crypto card on s390 */
	SC_ALLOW_ARG(__NR_ioctl, 1, ZSENDEP11CPRB),
#endif
#if defined(__x86_64__) && defined(__ILP32__) && defined(__X32_SYSCALL_BIT)
	/*
	 * On Linux x32, the clock_gettime VDSO falls back to the
	 * x86-64 syscall under some circumstances, e.g.
	 * https://bugs.debian.org/849923
	 */
	SC_ALLOW(__NR_clock_gettime & ~__X32_SYSCALL_BIT),
#endif

	/* Default deny */
	BPF_STMT(BPF_RET+BPF_K, SECCOMP_FILTER_FAIL),
};

static const struct sock_fprog preauth_program = {
	.len = (unsigned short)(sizeof(preauth_insns)/sizeof(preauth_insns[0])),
	.filter = (struct sock_filter *)preauth_insns,
};

static int install_seccomp_filter(void)
{
    struct rlimit rl_zero, rl_one = {.rlim_cur = 1, .rlim_max = 1};
    
    /* Set rlimits for completeness if possible. */
    rl_zero.rlim_cur = rl_zero.rlim_max = 0;
    if (setrlimit(RLIMIT_FSIZE, &rl_zero) == -1)
        fatal("%s: setrlimit(RLIMIT_FSIZE, { 0, 0 }): %s",
              __func__, strerror(errno));
    /*
     * Cannot use zero for nfds, because poll(2) will fail with
     * errno=EINVAL if npfds>RLIMIT_NOFILE.
     */
    if (setrlimit(RLIMIT_NOFILE, &rl_one) == -1)
        fatal("%s: setrlimit(RLIMIT_NOFILE, { 0, 0 }): %s",
              __func__, strerror(errno));
    if (setrlimit(RLIMIT_NPROC, &rl_zero) == -1)
        fatal("%s: setrlimit(RLIMIT_NPROC, { 0, 0 }): %s",
              __func__, strerror(errno));
    
    /* Enable seccomp mode */
    if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
        perror("prctl(PR_SET_NO_NEW_PRIVS)");
        return -1;
    }

    if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &preauth_program)) {
        perror("prctl(PR_SET_SECCOMP)");
        return -1;
    }

    return 0;
}

#define ASSERT(exp) do { \
    if ((exp)) \
        break; \
    fprintf(stderr, "%s:%d: %s: assertion %s failed.\n", \
            __FILE__, __LINE__, __PRETTY_FUNCTION__, #exp); \
    abort(); \
} while (0)

static size_t num_nodes = 40000;
static size_t repeat = 10;

struct foo;
typedef struct foo foo;

struct foo {
    foo* other;
    char* string;
};

static foo* root;

static void add_node(void)
{
    foo* node = (foo*)malloc(sizeof(foo));
    node->other = root;
    asprintf(&node->string, "node = %p", node);
    root = node;
}

static void build(void)
{
    size_t index;
    for (index = num_nodes; index--;)
        add_node();
}

static void remove_half(void)
{
    foo** ptr;
    size_t index;
    for (ptr = &root, index = 0; *ptr; index++) {
        if ((index & 1))
            ptr = &(*ptr)->other;
        else
            *ptr = (*ptr)->other;
    }
}

static void add_half(void)
{
    size_t index;
    for (index = num_nodes / 2; index--;)
        add_node();
}

static void verify(void)
{
    foo* node;
    for (node = root; node; node = node->other) {
        char* str;
        asprintf(&str, "node = %p", node);
        ASSERT(!strcmp(node->string, str));
    }
}

int main(void)
{
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stderr, NULL, _IONBF, 0);

    printf("Forking...\n");

    int out_pipe[2];
    ZASSERT(!pipe(out_pipe));

    int fork_result = fork();
    ZASSERT(fork_result >= 0);
    if (fork_result) {
        printf("In fork parent.\n");
        close(out_pipe[1]);

        for (;;) {
            char c;
            int read_result = read(out_pipe[0], &c, 1);
            if (!read_result)
                break;
            if (read_result < 0) {
                ZASSERT(errno == EINTR);
                continue;
            }
            ZASSERT(read_result == 1);
            ZASSERT(write(1, &c, 1) == 1);
        }

        int status;
        int wait_result = wait(&status);
        ZASSERT(wait_result == fork_result);
        ZASSERT(WIFEXITED(status));
        ZASSERT(!WEXITSTATUS(status));
        return 0;
    }

    close(out_pipe[0]);
    ZASSERT(dup2(out_pipe[1], 1) == 1);
    ZASSERT(dup2(out_pipe[1], 2) == 2);
    
    printf("Installing ssh's seccomp filter...\n");

    zlock_runtime_threads();

    if (install_seccomp_filter() < 0) {
        fprintf(stderr, "Failed to install seccomp filter\n");
        return 1;
    }

    printf("Seccomp filter installed successfully.\n");
    fflush(stdout);

    build();
    verify();
    size_t index;
    for (index = 1; index <= repeat; ++index) {
        printf("Iteration %zu\n", index);
        fflush(stdout);
        remove_half();
        verify();
        add_half();
        verify();
    }

    zgc_request_and_wait();
    
    printf("Success!\n");

    return 0;
}
