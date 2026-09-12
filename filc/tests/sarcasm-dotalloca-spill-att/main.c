#include <stdio.h>

long dotalloca_spill(long size, long align, long v);

int main(void)
{
    /* v + size = 5 + 48 */
    if (dotalloca_spill(48, 16, 5) != 53) {
        printf("FAIL spill\n");
        return 1;
    }
    printf("dotalloca spill ok\n");
    return 0;
}
