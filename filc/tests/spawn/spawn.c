#define _GNU_SOURCE

#include <stdfil.h>
#include <spawn.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <string.h>
#include <inttypes.h>

extern char** environ;

static void mywait_impl(int pid, int expected_exit_status)
{
    for (;;) {
        int status;
        int result = waitpid(pid, &status, 0);
        if (result == pid) {
            ZASSERT(WIFEXITED(status));
            ZASSERT(WEXITSTATUS(status) == expected_exit_status);
            break;
        }
        ZASSERT(result == -1);
        ZASSERT(errno == EINTR);
    }
}

static void mywait(int pid)
{
    mywait_impl(pid, 0);
}

static void spawn_and_wait(const char* path, const posix_spawn_file_actions_t* actions,
                           const posix_spawnattr_t* attrp, char*const* argv, char*const* envp)
{
    int pid;
    ZASSERT(!posix_spawn(&pid, path, actions, attrp, argv, envp));
    mywait(pid);
}

static void spawnp_and_wait(const char* path, const posix_spawn_file_actions_t* actions,
                            const posix_spawnattr_t* attrp, char*const* argv, char*const* envp)
{
    int pid;
    ZASSERT(!posix_spawnp(&pid, path, actions, attrp, argv, envp));
    mywait(pid);
}

static size_t readloop(int fd, char* data, size_t size)
{
    size_t bytes_read = 0;
    while (size) {
        ssize_t result = read(fd, data, size);
        zprintf("Read %ld bytes.\n", result);
        if (!result)
            return bytes_read;
        if (result == -1) {
            ZASSERT(errno == EINTR);
            continue;
        }
        ZASSERT(result > 0);
        ZASSERT(result <= size);
        data += result;
        size -= result;
        bytes_read += result;
    }
    return bytes_read;
}

int main()
{
    char* argv[] = { "/bin/sh", "-c", "echo Hello", NULL };
    zprintf("Spawn1: ");
    spawn_and_wait("/bin/sh", NULL, NULL, argv, environ);

    posix_spawn_file_actions_t actions;
    posix_spawn_file_actions_init(&actions);
    posix_spawnattr_t attr;
    posix_spawnattr_init(&attr);
    zprintf("Spawn2: ");
    spawn_and_wait("/bin/sh", &actions, &attr, argv, environ);

    posix_spawn_file_actions_addchdir_np(&actions, "/");
    char* argv2[] = { "/bin/sh", "-c", "echo $PWD", NULL };
    zprintf("Spawn3: ");
    spawn_and_wait("/bin/sh", &actions, &attr, argv2, environ);

    int pipefds[2];
    ZASSERT(!pipe(pipefds));
    posix_spawn_file_actions_adddup2(&actions, pipefds[1], 1);
    spawn_and_wait("/bin/sh", &actions, &attr, argv2, environ);
    close(pipefds[1]);
    char buf[100];
    size_t result = readloop(pipefds[0], buf, 100);
    ZASSERT(result == strlen("/\n"));
    ZASSERT(!strcmp(buf, "/\n"));
    
    zprintf("Spawn4: ");
    spawnp_and_wait("sh", NULL, NULL, argv, environ);

    char* argv3[] = { "/this/file/had/better/not/exist", NULL };
    int pid = 666;
    result = posix_spawn(&pid, "/this/file/had/better/not/exist", NULL, NULL, argv3, environ);
    ZASSERT(result);
    ZASSERT(result == ENOENT);
    ZASSERT(pid == 666);

    posix_spawn_file_actions_init(&actions);
    posix_spawn_file_actions_addclose(&actions, 0);
    posix_spawn_file_actions_addclose(&actions, 1);
    posix_spawn_file_actions_addclose(&actions, 2);
    zprintf("Spawn5: ");
    pid = 666;
    ZASSERT(!posix_spawn(&pid, "/bin/sh", &actions, &attr, argv, environ));
    mywait_impl(pid, 1);
    zprintf("<none>\n");

    posix_spawn_file_actions_init(&actions);
    ZASSERT(posix_spawn_file_actions_addclose(&actions, INT32_MAX) == EBADF);
    ZASSERT(posix_spawn_file_actions_addclose(&actions, -1) == EBADF);

    return 0;
}

