#include <stdio.h>

long pad_two(long p);

int main()
{
    /* Intel-syntax twin of sarcasm-pad-two-att. */
    unsigned long expect = 7UL + 0x2222222222222222UL + 0x1111111111111111UL;
    unsigned long got = (unsigned long)pad_two(7);
    if (got != expect) {
        printf("pad two = %lx want %lx\n", got, expect);
        return 1;
    }
    printf("pad two int ok\n");
    return 0;
}
