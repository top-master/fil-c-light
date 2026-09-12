#include <signal.h>
#include <stdfil.h>
#include <stdbool.h>

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

int main()
{
    ZASSERT(signal(SIGUSR1, handler) == SIG_DFL);
    ZASSERT(signal(SIGUSR1, handler2) == handler);
    ZASSERT(!raise(SIGUSR1));
    ZASSERT(!handler_called);
    ZASSERT(handler2_called);
    return 0;
}

