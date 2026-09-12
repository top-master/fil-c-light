#include <setjmp.h>
#include <stdfil.h>

static jmp_buf jump;

int main(void)
{
    volatile int uninitialized;
    volatile int initialized = 0;

    if (setjmp(jump) == 0)
    {
        uninitialized = 42;
        initialized = 42;
        longjmp(jump, 1);
    }

    ZASSERT(uninitialized == 42);
    ZASSERT(initialized == 42);

    return 0;
}
