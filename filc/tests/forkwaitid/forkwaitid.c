#include <unistd.h>
#include <stdio.h>
#include <sys/wait.h>
#include <stdfil.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <sys/types.h>

int main()
{
    int fork_result = fork();
    ZASSERT(fork_result >= 0);
    if (fork_result) {
        printf("Pozdrowienia od rodzicow\n");
        siginfo_t info;
        int wait_result = waitid(P_ALL, 0, &info, WEXITED | WSTOPPED | WCONTINUED);
        if (wait_result < 0)
            printf("wait error: %s\n", strerror(errno));
        ZASSERT(info.si_pid == fork_result);
        ZASSERT(info.si_signo == SIGCHLD);
        ZASSERT(!info.si_status);
        ZASSERT(info.si_code == CLD_EXITED);
    } else
        printf("Pozdrowienia od dzieci\n");
    
    return 0;
}

