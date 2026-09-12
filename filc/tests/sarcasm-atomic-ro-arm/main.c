#include <stdio.h>

/* swp on a read-only global: the CanWrite check must fire. */
long f(long* p, long v);

static const long rocell = 0;   /* read-only global object */

int main()
{
    printf("expect trap:\n");
    fflush(stdout);
    f((long*)&rocell, 1);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
