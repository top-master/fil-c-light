#include <stdfil.h>

/* VPGATHERQD gathers packed dword values from memory using VSIB (qword index)
   addressing. It is inherently a memory-access instruction with no
   register-only form, so it must be rejected by Fil-C's inline-asm safety
   validation. */

typedef int v4si __attribute__((vector_size(16)));

int main(void)
{
    v4si dst = {1, 2, 3, 4};
    v4si mask = {0x80000000, 0x80000000, 0x80000000, 0x80000000};
    asm volatile("vpgatherqd %%xmm2, (%%rax,%%xmm1,8), %%xmm0"
                 : "+x"(dst), "+x"(mask)
                 :
                 : "rax", "xmm1");
    return 0;
}
