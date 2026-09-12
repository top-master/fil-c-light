#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

static __attribute__((noinline)) unsigned sum_ld2(const unsigned char* p)
{
    uint8x16x2_t r = vld2q_u8(p);
    return (unsigned)r.val[0][0] + ((unsigned)r.val[1][15] << 8);
}

int main(void)
{
    unsigned char* buf = opaque(malloc(48));
    unsigned i;
    for (i = 0; i < 48; ++i)
        buf[i] = (unsigned char)(i * 3 + 1);
    ZASSERT(sum_ld2(buf) == (unsigned)buf[0] + ((unsigned)buf[31] << 8));
    /* The second call at the same callsite overruns the object. */
    ZASSERT(sum_ld2(buf + 32) == (unsigned)buf[32] + ((unsigned)buf[63] << 8));
    zprintf("Should have failed!\n");
    return 0;
}
