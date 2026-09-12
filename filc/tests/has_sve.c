#if defined(__aarch64__) && defined(__linux__)

#include <sys/auxv.h>
#include <asm/hwcap.h>
#include <stdio.h>
#include <stdbool.h>

/* Mirror of has_paca.c for SVE (FEAT_SVE). HWCAP_SVE reports whether the
   hardware implements the scalable vector extension. This gates the SVE
   inline-asm test (inlineasm_arm_z_clobbered): it executes SVE
   instructions, which would SIGILL on machines without the extension.
   (The run-tests harness builds this with the host compiler.) */

int main()
{
    unsigned long hwcap = getauxval(AT_HWCAP);

    printf("hwcap = %lx\n", hwcap);

    if (hwcap & HWCAP_SVE) {
        printf("SVE: OK\n");
        return 0;
    }
    printf("SVE: missing\n");
    return 1;
}

#else

int main()
{
    return 1;
}

#endif