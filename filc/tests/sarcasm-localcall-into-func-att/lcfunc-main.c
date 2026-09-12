#include <stdio.h>

extern void caller6(long *out);
extern void sum5(long *out, long a, long b, long c, long d, long e);

int main(void)
{
    long x = 0, y = 0;
    caller6(&x);                 /* local call into the alias-entry body: 1+2+3+4+5 */
    sum5(&y, 10, 20, 30, 40, 50); /* ordinary annotated Fil-C call to the export */
    if (x != 15) {
        printf("FAIL: local call wrote %ld, want 15\n", x);
        return 1;
    }
    if (y != 150) {
        printf("FAIL: exported call wrote %ld, want 150\n", y);
        return 1;
    }
    printf("localcall into func att ok\n");
    return 0;
}
