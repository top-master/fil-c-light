/* q0/q8/q16/q31 (64 bytes of NEON state) must survive the runtime calls
   inside an annotated `;! atomic store ptr` and an annotated `;! atomic load
   store ptr` compare-exchange loop; the barrier/RMW stores slot[1] into
   slot[0] (resp. adds 0 to the pointer slot). The return value is the sum of
   the eight 64-bit lanes, checked exactly under allocation churn (and
   FUGC_RAGE_MODE in the harness keeps the runtime paths hot). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdfil.h>
#include <filc_test_support.h>

#define ASSERT(exp) do { \
    if ((exp)) \
        break; \
    fprintf(stderr, "%s:%d: %s: assertion %s failed.\n", \
            __FILE__, __LINE__, __PRETTY_FUNCTION__, #exp); \
    abort(); \
} while (0)

long f_atomic_store(void** slot, char* buf);
long f_atomic_rmw(void** slot, char* buf);

int main()
{
    void** slot = malloc(2 * sizeof(void*));
    char* buf = malloc(64);
    ASSERT(slot && buf);
    uint64_t m0 = 0x0123456789abcdefULL;
    uint64_t m1 = 0xfedcba9876543210ULL;
    uint64_t m2 = 0x0f0e0d0c0b0a0908ULL;
    uint64_t m3 = 0x8877665544332211ULL;
    uint64_t m4 = 0x1122334455667788ULL;
    uint64_t m5 = 0x99aabbccddeeff00ULL;
    uint64_t m6 = 0xdeadbeefcafebabeULL;
    uint64_t m7 = 0x0badf00d12345678ULL;
    memcpy(buf, &m0, 8);
    memcpy(buf + 8, &m1, 8);
    memcpy(buf + 16, &m2, 8);
    memcpy(buf + 24, &m3, 8);
    memcpy(buf + 32, &m4, 8);
    memcpy(buf + 40, &m5, 8);
    memcpy(buf + 48, &m6, 8);
    memcpy(buf + 56, &m7, 8);
    long want = (long)(m0 + m1 + m2 + m3 + m4 + m5 + m6 + m7);
    size_t i, repeat = 20000;
    if (zgc_is_stw())
        repeat = 1000;
    for (i = 0; i < repeat; i++) {
        void* junk = malloc(64);
        memset(junk, 1, 64);
        free(junk);

        slot[0] = NULL;
        slot[1] = &buf[0];
        long got = f_atomic_store(slot, buf);
        ASSERT(got == want);
        ASSERT(slot[0] == &buf[0]);

        got = f_atomic_rmw(slot, buf);
        ASSERT(got == want);
        ASSERT(slot[0] == &buf[0]);     /* the +0 RMW kept the pointer */
    }
    printf("fp live atomic arm ok\n");
    return 0;
}
