#if defined(__aarch64__) && defined(__linux__)

#include <sys/auxv.h>
#include <asm/hwcap.h>
#include <stdio.h>
#include <stdbool.h>

/* Mirror of has_avx512.c for the ARMv8 cryptographic extension. The x86
   probe uses cpuid; the ARM equivalent of cpuid is the kernel's hwcap
   bits. (The run-tests harness builds this with the host compiler, and
   __builtin_cpu_supports is not usable here: Ubuntu 22.04's clang 14
   doesn't have it on aarch64, and blindly executing an AESE to "detect"
   would SIGILL on machines without the extension instead of returning 1,
   which run-tests treats as a hard error.) */

#define TEST(feature) do { \
        if (hwcap & HWCAP_ ## feature) \
            printf("%s: OK\n", #feature); \
        else { \
            printf("%s: missing\n", #feature); \
            all_good = false; \
        } \
    } while (false)

int main()
{
    unsigned long hwcap = getauxval(AT_HWCAP);

    printf("hwcap = %lx\n", hwcap);

    bool all_good = true;

    TEST(AES);
    TEST(PMULL);
    TEST(SHA1);
    TEST(SHA2);

    return all_good ? 0 : 1;
}

#else

int main()
{
    return 1;
}

#endif
