#include <stdio.h>

long nop_pad(long p);

int main()
{
    /* Intel-syntax twin of sarcasm-nops-att. */
    if (nop_pad(41) != 42) {
        printf("nop_pad = %ld\n", nop_pad(41));
        return 1;
    }
    printf("nops int ok\n");
    return 0;
}
