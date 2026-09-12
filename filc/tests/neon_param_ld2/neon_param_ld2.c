#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

static __attribute__((noinline)) unsigned do_ld2(const unsigned char* p)
{
    uint8x16x2_t r = vld2q_u8(p);
    return (unsigned)r.val[0][3] + ((unsigned)r.val[1][7] << 8);
}

int main(void)
{
    unsigned char buf[64];
    unsigned i;
    for (i = 0; i < 64; ++i)
        buf[i] = (unsigned char)(i * 9 + 1);
    unsigned got = do_ld2(buf);
    unsigned want = (unsigned)buf[6] + ((unsigned)buf[15] << 8);
    ZASSERT(got == want);
    got = do_ld2(buf + 32);
    want = (unsigned)buf[32 + 6] + ((unsigned)buf[32 + 15] << 8);
    ZASSERT(got == want);
    zprintf("neon param ld2 test passed!\n");
    return 0;
}
