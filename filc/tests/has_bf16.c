#if defined(__aarch64__) && defined(__linux__)

#include <sys/auxv.h>
#include <asm/hwcap.h>
#include <stdio.h>
#include <stdbool.h>

/* Mirror of has_lse.c for the BFloat16 instructions (bfcvt/bfcvtn/bfdot/
   ... FEAT_BF16). BF16 lives in the second hwcap word on ARM64, so this
   reads AT_HWCAP2. (The run-tests harness builds this with the host
   compiler, and blindly executing a BF16 instruction to "detect" would
   SIGILL on machines without the extension instead of returning 1, which
   run-tests treats as a hard error.) */

int main()
{
    unsigned long hwcap2 = getauxval(AT_HWCAP2);

    printf("hwcap2 = %lx\n", hwcap2);

    if (hwcap2 & HWCAP2_BF16) {
        printf("BF16: OK\n");
        return 0;
    }
    printf("BF16: missing\n");
    return 1;
}

#else

int main()
{
    return 1;
}

#endif
