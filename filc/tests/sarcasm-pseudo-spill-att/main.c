#include <stdio.h>

long pseudo_spill(long a0, long a1, long a2, long a3, long a4, long a5,
    long a6, long a7, long a8, long a9, long a10, long a11, long a12,
    long a13, long a14, long a15);

int main(void)
{
    long r = pseudo_spill(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
    if (r != 120) {
        printf("FAIL spill %ld\n", r);
        return 1;
    }
    printf("pseudo spill ok\n");
    return 0;
}
