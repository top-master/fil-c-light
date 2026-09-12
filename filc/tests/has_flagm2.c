#if defined(__aarch64__) && defined(__linux__)

#include <sys/auxv.h>
#include <asm/hwcap.h>
#include <stdio.h>
#include <stdbool.h>

/* Mirror of has_flagm.c for the Armv8.4.2 flag manipulation instructions
   (the setf16/setf64 forms on top of FEAT_FLAGM, FEAT_FLAGM2). FLAGM2
   lives in the second hwcap word on ARM64, so this reads AT_HWCAP2. (The
   run-tests harness builds this with the host compiler, and blindly
   executing a flagm2 instruction to "detect" would SIGILL on machines
   without the extension instead of returning 1, which run-tests treats as
   a hard error.) */

int main()
{
    unsigned long hwcap2 = getauxval(AT_HWCAP2);

    printf("hwcap2 = %lx\n", hwcap2);

    if (hwcap2 & HWCAP2_FLAGM2) {
        printf("FLAGM2: OK\n");
        return 0;
    }
    printf("FLAGM2: missing\n");
    return 1;
}

#else

int main()
{
    return 1;
}

#endif
