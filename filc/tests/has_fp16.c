#if defined(__aarch64__) && defined(__linux__)

#include <sys/auxv.h>
#include <asm/hwcap.h>
#include <stdio.h>
#include <stdbool.h>

/* Mirror of has_armcrypto.c for the ARMv8.2-FP16 half-precision arithmetic
   instructions (fadd/fsub/fmul/fdiv on h registers, fcvt between h and
   s/d). The x86 probe uses cpuid; the ARM equivalent of cpuid is the
   kernel's hwcap bits. HWCAP_FPHP covers SCALAR half-precision — the only
   form the gated tests use (sarcasm-fp-half-arm is scalar-only); a test
   using VECTOR half-precision (v-register .h arrangements) would
   additionally need HWCAP_ASIMDHP. (The run-tests harness builds this with
   the host compiler, and blindly executing an FP16 instruction to "detect"
   would SIGILL on machines without the extension instead of returning 1,
   which run-tests treats as a hard error.) */

int main()
{
    unsigned long hwcap = getauxval(AT_HWCAP);

    printf("hwcap = %lx\n", hwcap);

    if (hwcap & HWCAP_FPHP) {
        printf("FPHP: OK\n");
        return 0;
    }
    printf("FPHP: missing\n");
    return 1;
}

#else

int main()
{
    return 1;
}

#endif
