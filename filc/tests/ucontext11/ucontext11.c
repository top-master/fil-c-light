#include <stdfil.h>
#include <ucontext.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>

int main()
{
    ucontext_t ctx;
    ucontext_t ctx2;
    swapcontext(&ctx2, &ctx);
    return 0;
}

