#if defined(__aarch64__) && defined(__linux__)

#include <sys/auxv.h>
#include <asm/hwcap.h>
#include <stdio.h>
#include <stdbool.h>

/* Mirror of has_armcrypto.c for the SHA-512 cryptographic hash instructions
   (sha512h/sha512h2/sha512su0/sha512su1, FEAT_SHA512). (The run-tests
   harness builds this with the host compiler, and blindly executing a
   sha512 instruction to "detect" would SIGILL on machines without the
   extension instead of returning 1, which run-tests treats as a hard
   error.) */

int main()
{
    unsigned long hwcap = getauxval(AT_HWCAP);

    printf("hwcap = %lx\n", hwcap);

    if (hwcap & HWCAP_SHA512) {
        printf("SHA512: OK\n");
        return 0;
    }
    printf("SHA512: missing\n");
    return 1;
}

#else

int main()
{
    return 1;
}

#endif
