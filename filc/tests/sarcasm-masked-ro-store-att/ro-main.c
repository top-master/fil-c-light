#include <stdio.h>

void f(void* p, long k);

static const long rovec[8] = { 0, 1, 2, 3, 4, 5, 6, 7 };   /* read-only global object */

int main()
{
    printf("setup ok\n");
    /* A masked store to a read-only object traps on CanWrite even with a
       valid, in-bounds address. */
    f((void*)rovec, 0xFF);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
