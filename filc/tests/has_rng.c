#if defined(__aarch64__) && defined(__linux__)

#include <sys/auxv.h>
#include <asm/hwcap.h>
#include <stdio.h>
#include <stdbool.h>

/* Mirror of has_lse.c for the architectural random number generator (mrs
   rndr/mrs rndrrs, FEAT_RNG). HWCAP2_RNG lives in the second hwcap word on
   ARM64, so this reads AT_HWCAP2. This probe gates the inlineasm_arm_mrs_rng
   test: rndr/rndrrs are in the inline asm mrs allowlist, but a read of
   either register also writes PSTATE.Z (Z = 1 means the entropy source
   failed to produce a value), which is why those asm statements must carry
   the "cc" clobber. (The run-tests harness builds this with the host
   compiler, and blindly executing mrs rndr to "detect" would SIGILL on
   machines without the extension instead of returning 1, which run-tests
   treats as a hard error.) */

int main()
{
    unsigned long hwcap2 = getauxval(AT_HWCAP2);

    printf("hwcap2 = %lx\n", hwcap2);

    if (hwcap2 & HWCAP2_RNG) {
        printf("RNG: OK\n");
        return 0;
    }
    printf("RNG: missing\n");
    return 1;
}

#else

int main()
{
    return 1;
}

#endif
