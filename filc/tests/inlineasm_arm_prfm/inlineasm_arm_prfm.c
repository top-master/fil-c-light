#include <stdfil.h>

int main(void)
{
    unsigned long data[16];
    for (int i = 0; i < 16; ++i)
        data[i] = (unsigned long)i;
    unsigned long addr = (unsigned long)data;

    /* Base register forms. */
    asm volatile("prfm pldl1keep, [%0]" : : "r"(addr));
    asm volatile("prfm pldl1keep, [%0, #8]" : : "r"(addr));
    asm volatile("prfm pldl1strm, [%0, #16]" : : "r"(addr));
    asm volatile("prfm pldl2keep, [%0, #24]" : : "r"(addr));
    asm volatile("prfm pldl3keep, [%0, #32]" : : "r"(addr));
    asm volatile("prfm plil1keep, [%0, #40]" : : "r"(addr));
    asm volatile("prfm pstl1keep, [%0, #48]" : : "r"(addr));
    asm volatile("prfm pstl2strm, [%0, #56]" : : "r"(addr));

    /* Unscaled offset form. */
    asm volatile("prfum pldl1keep, [%0, #-4]" : : "r"(addr + 4));

    /* Literal base register (no operand). */
    asm volatile("prfm pldl1keep, [x1]" : : "r"(addr));

    /* Shifted register offset: the trailing "lsl #3" modifier attaches to
       the preceding register piece of the address. */
    asm volatile("prfm pldl1keep, [x0, x1, lsl #3]" : : "r"(addr));
    asm volatile("prfm pldl1strm, [%0, %1, lsl #3]"
                 : : "r"(addr), "r"(8UL));

    /* Extended register offset forms (the 32-bit source register is
       sign/zero-extended to form the offset). */
    asm volatile("prfm pldl2keep, [x0, w1, sxtw]" : : "r"(addr));
    asm volatile("prfm pldl3keep, [x0, w1, uxtw]" : : "r"(addr));
    asm volatile("prfm plil1keep, [x0, x2, sxtx]" : : "r"(addr));

    /* prfm does not change memory: data must be intact. */
    for (int i = 0; i < 16; ++i)
        ZASSERT(data[i] == (unsigned long)i);
    return 0;
}
