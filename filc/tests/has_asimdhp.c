#if defined(__aarch64__) && defined(__linux__)

#include <sys/auxv.h>
#include <asm/hwcap.h>
#include <stdio.h>
#include <stdbool.h>

/* Mirror of has_fp16.c for VECTOR half-precision arithmetic — the fadd/fsub/
   fmul/fdiv/fmla/... instructions on v-register .h arrangements, plus the
   half-precision vector loads and conversions gated on FEAT_FP16 for the
   SIMD data path (asimdhp in /proc/cpuinfo's hwcaps). A test using VECTOR
   half-precision needs this bit in addition to the scalar HWCAP_FPHP bit
   that has_fp16.c checks. (The run-tests harness builds this with the host
   compiler, and blindly executing a vector half-precision instruction to
   "detect" would SIGILL on machines without the extension instead of
   returning 1, which run-tests treats as a hard error.) */

int main()
{
    unsigned long hwcap = getauxval(AT_HWCAP);

    printf("hwcap = %lx\n", hwcap);

    if (hwcap & HWCAP_ASIMDHP) {
        printf("ASIMDHP: OK\n");
        return 0;
    }
    printf("ASIMDHP: missing\n");
    return 1;
}

#else

int main()
{
    return 1;
}

#endif
