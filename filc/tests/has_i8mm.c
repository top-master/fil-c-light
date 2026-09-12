#if defined(__aarch64__) && defined(__linux__)

#include <sys/auxv.h>
#include <asm/hwcap.h>
#include <stdio.h>
#include <stdbool.h>

/* Mirror of has_lse.c for the 8-bit integer matrix multiply instructions
   (smmla/ummla/usmmla/usdot, FEAT_I8MM). I8MM lives in the second hwcap
   word on ARM64, so this reads AT_HWCAP2. (The run-tests harness builds
   this with the host compiler, and blindly executing an i8mm instruction
   to "detect" would SIGILL on machines without the extension instead of
   returning 1, which run-tests treats as a hard error.) */

int main()
{
    unsigned long hwcap2 = getauxval(AT_HWCAP2);

    printf("hwcap2 = %lx\n", hwcap2);

    if (hwcap2 & HWCAP2_I8MM) {
        printf("I8MM: OK\n");
        return 0;
    }
    printf("I8MM: missing\n");
    return 1;
}

#else

int main()
{
    return 1;
}

#endif
