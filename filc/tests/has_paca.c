#if defined(__aarch64__) && defined(__linux__)

#include <sys/auxv.h>
#include <asm/hwcap.h>
#include <stdio.h>
#include <stdbool.h>

/* Mirror of has_lse.c for pointer authentication code (pacia/pacda/paciasp/
   autia/... FEAT_PAuth). HWCAP_PACA reports whether the hardware implements
   address authentication with the generic PAC algorithm (the kernel also
   has to have enabled it). This probe gates the PAC inline-asm tests
   (inlineasm_arm_pacia): the validator accepts pacia/pacib/autia/autib/
   pacda/pacdb/autda/autdb/pacga/xpaci/xpacd plus the LR forms, and README
   advertises that support. (The run-tests harness builds this with the
   host compiler.) */

int main()
{
    unsigned long hwcap = getauxval(AT_HWCAP);

    printf("hwcap = %lx\n", hwcap);

    if (hwcap & HWCAP_PACA) {
        printf("PACA: OK\n");
        return 0;
    }
    printf("PACA: missing\n");
    return 1;
}

#else

int main()
{
    return 1;
}

#endif
