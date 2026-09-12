#if defined(__aarch64__) && defined(__linux__)

#include <sys/auxv.h>
#include <asm/hwcap.h>
#include <stdio.h>
#include <stdbool.h>

/* Mirror of has_lse.c for the FEAT_JSCVT conversion instruction (fjcvtzs),
   which the inline-asm validator classifies as flag-setting (it writes
   PSTATE.NZCV in addition to the destination register). The x86 probe uses
   cpuid; the ARM equivalent of cpuid is the kernel's hwcap bits. (The
   run-tests harness builds this with the host compiler, and blindly
   executing fjcvtzs to "detect" would SIGILL on machines without the
   extension instead of returning 1, which run-tests treats as a hard
   error.) */

int main()
{
    unsigned long hwcap = getauxval(AT_HWCAP);

    printf("hwcap = %lx\n", hwcap);

    if (hwcap & HWCAP_JSCVT) {
        printf("JSCVT: OK\n");
        return 0;
    }
    printf("JSCVT: missing\n");
    return 1;
}

#else

int main()
{
    return 1;
}

#endif
