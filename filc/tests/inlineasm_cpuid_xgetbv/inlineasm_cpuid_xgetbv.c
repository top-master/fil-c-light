#include <stdfil.h>
#include <stdint.h>
#include <string.h>

int main(void)
{
    uint32_t eax, ebx, ecx, edx;
    char vendor[13];

    /* CPUID leaf 0: get vendor string. */
    eax = 0;
    ecx = 0;
    asm volatile("cpuid\n\t"
                 : "+a"(eax), "=b"(ebx), "+c"(ecx), "=d"(edx));

    /* Assemble vendor string from ebx, edx, ecx in that order. */
    *(uint32_t *)&vendor[0] = ebx;
    *(uint32_t *)&vendor[4] = edx;
    *(uint32_t *)&vendor[8] = ecx;
    vendor[12] = '\0';

    zprintf("vendor = %s\n", vendor);
    zprintf("cpuid(0) max leaf = %u\n", eax);

    /* The vendor string should be exactly 12 characters. */
    ZASSERT(strlen(vendor) == 12);
    ZASSERT(eax != 0);
    ZASSERT(ebx != 0);
    ZASSERT(ecx != 0);
    ZASSERT(edx != 0);

    /* CPUID leaf 1: processor info and features. */
    eax = 1;
    ecx = 0;
    asm volatile("cpuid\n\t"
                 : "+a"(eax), "=b"(ebx), "+c"(ecx), "=d"(edx));

    zprintf("cpuid(1) eax = %u, ebx = %u, ecx = %u, edx = %u\n",
            eax, ebx, ecx, edx);
    ZASSERT(eax != 0);

    /* XGETBV with ecx = 0: read XCR0. */
    uint32_t xcr0_lo, xcr0_hi;
    asm volatile("xgetbv\n\t"
                 : "=a"(xcr0_lo), "=d"(xcr0_hi)
                 : "c"(0));

    zprintf("xgetbv(0) = 0x%x%08x\n", xcr0_hi, xcr0_lo);

    return 0;
}
