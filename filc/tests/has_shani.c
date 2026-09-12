#ifdef __x86_64__

#include <cpuid.h>
#include <stdio.h>
#include <stdbool.h>

/* Probe for Intel SHA extensions (SHA-NI: SHA1+SHA256 instructions):
   CPUID leaf 7, EBX bit 29 (bit_SHA in gcc's cpuid.h). Mirrors has_avx512.c. */

static void do_cpuid(unsigned* eax, unsigned* ebx, unsigned* ecx, unsigned* edx)
{
#ifdef __PIZLONATOR_WAS_HERE__
    unsigned level = *eax;
    __get_cpuid(level, eax, ebx, ecx, edx);
#else
    unsigned a = *eax, b, c = *ecx, d;
    asm volatile("cpuid\n\t" : "+a"(a), "=b"(b), "+c"(c), "=d"(d));
    *eax = a;
    *ebx = b;
    *ecx = c;
    *edx = d;
#endif
}

int main()
{
    unsigned eax = 0x7;
    unsigned ebx = 0;
    unsigned ecx = 0;
    unsigned edx = 0;

    do_cpuid(&eax, &ebx, &ecx, &edx);

    printf("eax = %x, ebx = %x, ecx = %x, edx = %x\n", eax, ebx, ecx, edx);

    bool all_good = true;
    if (ebx & bit_SHA)
        printf("SHA: OK\n");
    else {
        printf("SHA: missing\n");
        all_good = false;
    }

    return all_good ? 0 : 1;
}

#else

int main()
{
    return 1;
}

#endif
