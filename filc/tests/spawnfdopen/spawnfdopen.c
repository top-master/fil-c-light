#define _GNU_SOURCE

#include <stdfil.h>
#include <spawn.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>

extern char** environ;

static void mywait(int pid)
{
    for (;;) {
        int status;
        int result = waitpid(pid, &status, 0);
        if (result == pid) {
            ZASSERT(WIFEXITED(status));
            ZASSERT(!WEXITSTATUS(status));
            break;
        }
        ZASSERT(result == -1);
        ZASSERT(errno == EINTR);
    }
}

int main()
{
    /* Create a temporary file with some content. */
    char tmpfile[] = "/tmp/spawnfdopen_XXXXXX";
    int tmpfd = mkstemp(tmpfile);
    ZASSERT(tmpfd >= 0);

    const char* message = "Hello from FDOP_OPEN\n";
    ssize_t written = write(tmpfd, message, strlen(message));
    ZASSERT(written == (ssize_t)strlen(message));
    close(tmpfd);

    /* Set up file actions to open the temp file as stdin (fd 0) in the child. */
    posix_spawn_file_actions_t actions;
    ZASSERT(!posix_spawn_file_actions_init(&actions));
    ZASSERT(!posix_spawn_file_actions_addopen(&actions, 0, tmpfile, O_RDONLY, 0));

    /* Spawn cat to read from the file opened as stdin. */
    char* argv[] = { "/bin/cat", NULL };
    int pid;
    zprintf("SpawnFdOpen: ");
    ZASSERT(!posix_spawn(&pid, "/bin/cat", &actions, NULL, argv, environ));
    mywait(pid);

    posix_spawn_file_actions_destroy(&actions);
    unlink(tmpfile);

    return 0;
}
