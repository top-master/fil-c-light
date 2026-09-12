#include <stdfil.h>

int main(void)
{
    /* PAUSE is a no-op hint for spin-wait loops; it does not modify any
       architectural state. */
    asm volatile("pause");
    ZASSERT(1);
    return 0;
}
