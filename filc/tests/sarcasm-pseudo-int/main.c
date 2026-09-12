#include <stdio.h>

long pseudo_intel(long a, long b);

int main(void)
{
    if (pseudo_intel(3, 4) != 7) {
        printf("FAIL intel\n");
        return 1;
    }
    printf("pseudo intel ok\n");
    return 0;
}
