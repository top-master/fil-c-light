#include <stdfil.h>

/* VPGATHERQQ gathers packed qword values from memory using VSIB (qword index)
   addressing. It is inherently a memory-access instruction with no
   register-only form, so it must be rejected by Fil-C's inline-asm safety
   validation. */

typedef long long v2di __attribute__((vector_size(16)));

int main(void)
{
    v2di dst = {1, 2};
    v2di mask = {0x8000000000000000LL, 0x8000000000000000LL};
    asm volatile("vpgatherqq %%xmm2, (%%rax,%%xmm1,8), %%xmm0"
                 : "+x"(dst), "+x"(mask)
                 :
                 : "rax", "xmm1");
    return 0;
}
