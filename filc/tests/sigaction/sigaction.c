#include <signal.h>
#include <stdfil.h>
#include <stdbool.h>
#include <string.h>

typedef void (*sighandler_t)(int);

static bool handler_called = false;
static void handler(int signo)
{
    zprintf("handler!\n");
    ZASSERT(signo == SIGUSR1);
    handler_called = true;
}

static bool handler2_called = false;
static void handler2(int signo)
{
    zprintf("handler2!\n");
    ZASSERT(signo == SIGUSR1);
    handler2_called = true;
}

static sighandler_t my_signal(int signum, sighandler_t handler)
{
    struct sigaction act;
    struct sigaction oact;
    bzero(&act, sizeof(act));
    bzero(&oact, sizeof(oact));
    act.sa_handler = handler;
    ZASSERT(!sigfillset(&act.sa_mask));
    ZASSERT(!sigaction(signum, &act, &oact));
    return oact.sa_handler;
}

int main()
{
    ZASSERT(my_signal(SIGUSR1, handler) == SIG_DFL);
    ZASSERT(my_signal(SIGUSR1, handler2) == handler);
    ZASSERT(!raise(SIGUSR1));
    ZASSERT(!handler_called);
    ZASSERT(handler2_called);
    return 0;
}

