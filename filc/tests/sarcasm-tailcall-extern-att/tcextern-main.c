#include <stdio.h>

long c_cube(long x) { return x * x * x; }

extern long maybe_cubed(long x);

int main(void)
{
    long r1 = maybe_cubed(5);   /* -> c_cube: 125 */
    long r2 = maybe_cubed(0);   /* fallthrough: 1 */
    if (r1 != 125 || r2 != 1) {
        printf("FAIL: got %ld %ld\n", r1, r2);
        return 1;
    }
    printf("tailcall extern att ok\n");
    return 0;
}
