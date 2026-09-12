#if defined(__aarch64__) && defined(__linux__)

#include <sys/auxv.h>
#include <asm/hwcap.h>
#include <stdio.h>
#include <stdbool.h>

/* Mirror of has_armcrypto.c for the ARMv8.1 LSE (Large System Extensions)
   atomic instructions (swp/ldadd/cas/casp & co). The x86 probe uses cpuid;
   the ARM equivalent of cpuid is the kernel's hwcap bits. (The run-tests
   harness builds this with the host compiler, and blindly executing an LSE
   instruction to "detect" would SIGILL on machines without the extension
   instead of returning 1, which run-tests treats as a hard error.) */

int main()
{
    unsigned long hwcap = getauxval(AT_HWCAP);

    printf("hwcap = %lx\n", hwcap);

    if (hwcap & HWCAP_ATOMICS) {
        printf("ATOMICS: OK\n");
        return 0;
    }
    printf("ATOMICS: missing\n");
    return 1;
}

#else

int main()
{
    return 1;
}

#endif
