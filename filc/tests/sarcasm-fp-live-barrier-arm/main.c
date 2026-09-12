/* q0 = buf[0..16) and q8 = buf[16..32) must survive the store-ptr barrier
   slow path; the barrier stores slot[1] into slot[0]. The return value is
   the sum of the four 64-bit lanes, checked exactly under allocation churn
   (and FUGC_RAGE_MODE in the harness keeps the barrier on its slow path). */
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

long f_barrier(void** slot, char* buf);

int main()
{
    void** slot = malloc(2 * sizeof(void*));
    char* buf = malloc(32);
    ASSERT(slot && buf);
    uint64_t m0 = 0x0123456789abcdefULL;
    uint64_t m1 = 0xfedcba9876543210ULL;
    uint64_t m2 = 0x0f0e0d0c0b0a0908ULL;
    uint64_t m3 = 0x8877665544332211ULL;
    memcpy(buf, &m0, 8);
    memcpy(buf + 8, &m1, 8);
    memcpy(buf + 16, &m2, 8);
    memcpy(buf + 24, &m3, 8);
    long want = (long)(m0 + m1 + m2 + m3);
    size_t i, repeat = 30000;
    if (zgc_is_stw())
        repeat = 1000;
    for (i = 0; i < repeat; i++) {
        void* junk = malloc(64);
        memset(junk, 1, 64);
        free(junk);

        slot[0] = NULL;
        slot[1] = &buf[0];
        long got = f_barrier(slot, buf);
        ASSERT(got == want);
        ASSERT(slot[0] == &buf[0]);
    }
    printf("fp barrier ok\n");
    return 0;
}
