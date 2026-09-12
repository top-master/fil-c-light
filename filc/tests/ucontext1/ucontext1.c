#include <stdfil.h>
#include <ucontext.h>

static ucontext_t ctx_main;
static ucontext_t ctx_func1;
static ucontext_t ctx_func2;

static void func1(void)
{
    zprintf("func1(swapcontext);");
    swapcontext(&ctx_func1, &ctx_func2);
    zprintf("func1(exit);");
}

static void func2(void)
{
    zprintf("func2(swapcontext);");
    swapcontext(&ctx_func2, &ctx_func1);
    zprintf("func2(exit);");
}

int main()
{
    getcontext(&ctx_func1);
    ctx_func1.uc_stack.ss_size = 16384;
    ctx_func1.uc_link = &ctx_main;
    makecontext(&ctx_func1, func1, 0);

    getcontext(&ctx_func2);
    ctx_func2.uc_stack.ss_size = 16384;
    ctx_func2.uc_link = &ctx_func1;
    makecontext(&ctx_func2, func2, 0);

    zprintf("main(swapcontext);");
    swapcontext(&ctx_main, &ctx_func2);
    zprintf("main(exiting);\n");

    return 0;
}

