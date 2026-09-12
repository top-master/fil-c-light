#include <unistd.h>
#include <signal.h>
#include <stdfil.h>
#include <stdbool.h>
#include <stdio.h>
#include <errno.h>
#include <pthread.h>
#include <sys/wait.h>
#include <string.h>

static bool gotit = false;

static void handler(int signo)
{
    ZASSERT(signo == SIGALRM);
    gotit = true;
}

int main()
{
    signal(SIGALRM, handler);
    sigset_t set;
    ZASSERT(!sigemptyset(&set));
    ZASSERT(!sigaddset(&set, SIGALRM));
    int fork_result = fork();
    ZASSERT(fork_result >= 0);
    ZASSERT(!pthread_sigmask(SIG_BLOCK, &set, NULL));
    ualarm(1000, 0);
    int signum;
    ZASSERT(!sigwait(&set, &signum));
    ZASSERT(signum == SIGALRM);
    if (fork_result) {
        int status;
        int wait_result = wait(&status);
        if (wait_result < 0)
            printf("wait error: %s\n", strerror(errno));
        ZASSERT(wait_result == fork_result);
        ZASSERT(WIFEXITED(status));
        ZASSERT(!WEXITSTATUS(status));
    }
    printf("Znakomicie\n");
    return 0;
}

