#if defined(__aarch64__) && defined(__linux__)

#include <sys/auxv.h>
#include <asm/hwcap.h>
#include <stdio.h>
#include <stdbool.h>

/* Mirror of has_lse.c for the CRC-32 checksum instructions (crc32b/crc32h/
   crc32cb/... FEAT_CRC32, optional from Armv8.0-A). (The run-tests harness
   builds this with the host compiler, and blindly executing a crc32
   instruction to "detect" would SIGILL on machines without the extension
   instead of returning 1, which run-tests treats as a hard error.) */

int main()
{
    unsigned long hwcap = getauxval(AT_HWCAP);

    printf("hwcap = %lx\n", hwcap);

    if (hwcap & HWCAP_CRC32) {
        printf("CRC32: OK\n");
        return 0;
    }
    printf("CRC32: missing\n");
    return 1;
}

#else

int main()
{
    return 1;
}

#endif
