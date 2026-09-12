#include <stdio.h>

long leaidxc_single(long i, long addend);
long leaidxc_two(long i, long addend);
long leaidxc_spill(long i, long addend);

int main(void)
{
    for (long i = 0; i < 4; i++) {
        long s = leaidxc_single(i, 1000);
        long t = leaidxc_two(i, 1000);
        if (s != 1100 + i || t != 1100 + i) {
            printf("FAIL i=%ld single=%ld two=%ld\n", i, s, t);
            return 1;
        }
        /* spill-derived base, single-step lea, in-clone and $-16:
           ((100+i) & -16) + 1000. */
        long p = leaidxc_spill(i, 1000);
        if (p != ((100 + i) & -16L) + 1000) {
            printf("FAIL spill i=%ld got=%ld\n", i, p);
            return 1;
        }
    }
    printf("lea idx clone att ok\n");
    return 0;
}
