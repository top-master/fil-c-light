#include <stdio.h>

long dotalloca_roundtrip(long v);
void *dotalloca_buf32(void);
void *dotalloca_buf64(void);

int main(void)
{
    if (dotalloca_roundtrip(41) != 170) {
        printf("FAIL roundtrip\n");
        return 1;
    }
    /* Uninitialized reads of a fresh allocation trap, so just check the
       returned alignment here. */
    if (((unsigned long)dotalloca_buf32() & 31) != 0) {
        printf("FAIL align32\n");
        return 1;
    }
    if (((unsigned long)dotalloca_buf64() & 63) != 0) {
        printf("FAIL align64\n");
        return 1;
    }
    printf("dotalloca imm ok\n");
    return 0;
}
