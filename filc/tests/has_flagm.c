#if defined(__aarch64__) && defined(__linux__)

#include <sys/auxv.h>
#include <asm/hwcap.h>
#include <stdio.h>
#include <stdbool.h>

/* Mirror of has_lse.c for the Armv8.4 flag manipulation instructions (cfinv/
   rmif/setf8/setf16/setf32/axflag/xaflag, FEAT_FLAGM). (The run-tests
   harness builds this with the host compiler, and blindly executing a
   flagm instruction to "detect" would SIGILL on machines without the
   extension instead of returning 1, which run-tests treats as a hard
   error.) */

int main()
{
    unsigned long hwcap = getauxval(AT_HWCAP);

    printf("hwcap = %lx\n", hwcap);

    if (hwcap & HWCAP_FLAGM) {
        printf("FLAGM: OK\n");
        return 0;
    }
    printf("FLAGM: missing\n");
    return 1;
}

#else

int main()
{
    return 1;
}

#endif
