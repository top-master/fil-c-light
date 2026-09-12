#include <stdio.h>

long dotalloca_reg(long size, long align, long v);

int main(void)
{
    if (dotalloca_reg(24, 16, 7) != 7) {
        printf("FAIL reg16\n");
        return 1;
    }
    if (dotalloca_reg(24, 32, 9) != 9) {
        printf("FAIL reg32\n");
        return 1;
    }
    printf("dotalloca reg ok\n");
    return 0;
}
