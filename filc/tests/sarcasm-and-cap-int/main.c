#include <stdio.h>
#include <stdlib.h>

void and_imm16(unsigned long *p, unsigned long *out);
void and_regmask(unsigned long *p, unsigned long *out, unsigned long mask);
void and_down8(unsigned long *p, unsigned long *out);
unsigned long and_alloca16(unsigned long v);

int main(void)
{
    unsigned long *p = malloc(64);
    unsigned long out = 0;
    if (!p)
        return 1;
    for (int i = 0; i < 8; i++)
        p[i] = 100 + i;
    /* malloc is 16-aligned: and $-16 is a value no-op, cap preserved. */
    and_imm16(p, &out);
    if (out != 100) {
        printf("FAIL and_imm16 got %lu\n", out);
        return 1;
    }
    and_regmask(p, &out, ~15UL);
    if (out != 100) {
        printf("FAIL and_regmask got %lu\n", out);
        return 1;
    }
    /* p+8 masked back down to p: value changed, still in bounds. */
    and_down8(p, &out);
    if (out != 100) {
        printf("FAIL and_down8 got %lu\n", out);
        return 1;
    }
    if (and_alloca16(41) != 83) {
        printf("FAIL and_alloca16 got %lu\n", and_alloca16(41));
        return 1;
    }
    printf("and cap int ok\n");
    return 0;
}
