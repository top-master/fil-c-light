#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

long cpuid1_ecx(void);
void mon_arm(long* buf);
void mwait0(void);

static long* buf;

static void run_monitor_mwait(void)
{
    /* Arm the address monitor on buf, write buf (so a non-spurious mwait
       wakes immediately), then mwait with hints=0/extensions=0. mwait may
       return spuriously or after the write — either is fine; what matters is
       that it returns. */
    mon_arm(buf);
    buf[0] = 42;
    mwait0();
}

/* Returns 1 if userspace monitor/mwait execute, 0 if they #UD. Fil-C
   deliberately makes SIGILL uncatchable (a hardware trap is a safe halt), so
   the probe runs in a forked child and the parent inspects how it died. */
static int probe_monitor_mwait(void)
{
    pid_t pid = fork();
    if (pid < 0) {
        perror("fork");
        exit(1);
    }
    if (!pid) {
        run_monitor_mwait();
        _exit(0);
    }
    int status;
    while (waitpid(pid, &status, 0) != pid)
        ;
    return WIFEXITED(status) && WEXITSTATUS(status) == 0;
}

int main(void)
{
    buf = malloc(64);
    if (!buf)
        return 1;
    buf[0] = 0;

    /* MONITOR/MWAIT feature: CPUID leaf 1 ECX bit 3. */
    if (!((unsigned)cpuid1_ecx() & 8)) {
        printf("monitor att ok (MONITOR/MWAIT feature absent; skipped)\n");
        return 0;
    }
    /* The feature bit may be set while the OS still #UDs userspace
       MONITOR/MWAIT (the common case on Linux): probe in a child. */
    if (!probe_monitor_mwait()) {
        printf("monitor att ok (MONITOR/MWAIT #UD in userspace; skipped)\n");
        return 0;
    }
    run_monitor_mwait();
    printf("monitor att ok\n");
    return 0;
}
