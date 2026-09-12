#include <stdio.h>

long dotalloca_pseudo(long size, long align, long v);

int main(void)
{
    if (dotalloca_pseudo(40, 16, 11) != 11) {
        printf("FAIL pseudo\n");
        return 1;
    }
    if (dotalloca_pseudo(40, 64, 13) != 13) {
        printf("FAIL pseudo64\n");
        return 1;
    }
    printf("dotalloca pseudo ok\n");
    return 0;
}
