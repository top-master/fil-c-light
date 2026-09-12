#include <stdfil.h>
#include <ucontext.h>
#include <signal.h>
#include <stdlib.h>

static ucontext_t ctx_main;
static ucontext_t ctx_func1;
static ucontext_t ctx_func2;

static void handler(int signal)
{
    zprintf("handler;");
}

static void func1(void)
{
    zprintf("func1(sigmask);");
    sigset_t set;
    ZASSERT(!sigfillset(&set));
    ZASSERT(!pthread_sigmask(SIG_BLOCK, &set, NULL));
    zprintf("func1(swapcontext);");
    swapcontext(&ctx_func1, &ctx_func2);
    zprintf("func1(exit);");
}

static void func2(void)
{
    zprintf("func2(swapcontext);");
    swapcontext(&ctx_func2, &ctx_func1);
    zprintf("func2(raise);");
    raise(SIGTERM);
    zprintf("func2(exit);");
}

int main()
{
    ZASSERT(SIG_DFL == signal(SIGTERM, handler));
    
    getcontext(&ctx_func1);
    ctx_func1.uc_stack.ss_size = 16384;
    ctx_func1.uc_link = &ctx_main;
    makecontext(&ctx_func1, func1, 0);

    getcontext(&ctx_func2);
    ctx_func2.uc_stack.ss_size = 16384;
    ctx_func2.uc_link = &ctx_func1;
    sigfillset(&ctx_func2.uc_sigmask);
    makecontext(&ctx_func2, func2, 0);

    zprintf("main(swapcontext);");
    swapcontext(&ctx_main, &ctx_func2);
    zprintf("main(exiting);\n");

    return 0;
}

