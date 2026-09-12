#if defined(__aarch64__) && defined(__linux__)

#include <sys/auxv.h>
#include <asm/hwcap.h>
#include <stdio.h>
#include <stdbool.h>

/* Mirror of has_armcrypto.c for the SHA-3 cryptographic hash instructions
   (eor3/rax1/xar/bcax, FEAT_SHA3). Note that eor3 and bcax are plain AdvSIMD
   mnemonics gated on the SHA3 feature by the assembler. (The run-tests
   harness builds this with the host compiler, and blindly executing a sha3
   instruction to "detect" would SIGILL on machines without the extension
   instead of returning 1, which run-tests treats as a hard error.) */

int main()
{
    unsigned long hwcap = getauxval(AT_HWCAP);

    printf("hwcap = %lx\n", hwcap);

    if (hwcap & HWCAP_SHA3) {
        printf("SHA3: OK\n");
        return 0;
    }
    printf("SHA3: missing\n");
    return 1;
}

#else

int main()
{
    return 1;
}

#endif
