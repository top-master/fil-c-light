#include <arm_neon.h>
#include <stdint.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    char buf[64];
    unsigned i;
    for (i = 0; i < 64; ++i)
        buf[i] = (char)(i * 7 + 3);
    uint8x16x2_t r = vld2q_u8((unsigned char*)buf);
    for (i = 0; i < 16; ++i) {
        ZASSERT(r.val[0][i] == (unsigned char)buf[2 * i]);
        ZASSERT(r.val[1][i] == (unsigned char)buf[2 * i + 1]);
    }
    uint8x8x2_t r2 = vld2_u8((unsigned char*)buf + 48);
    for (i = 0; i < 8; ++i) {
        ZASSERT(r2.val[0][i] == (unsigned char)buf[48 + 2 * i]);
        ZASSERT(r2.val[1][i] == (unsigned char)buf[48 + 2 * i + 1]);
    }
    zprintf("neon stack ld2 test passed!\n");
    return 0;
}
