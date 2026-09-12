#include <stdfil.h>
#include <ucontext.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>

int main()
{
    ucontext_t ctx;
    getcontext(&ctx);
    setcontext(&ctx);
    return 0;
}

