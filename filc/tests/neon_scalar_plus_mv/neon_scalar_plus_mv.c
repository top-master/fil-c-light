#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(64));
    unsigned i, k, j;
    /* Scalar stores and a multi-vector load interleaved in the same function. */
    for (i = 0; i < 64; ++i)
        buf[i] = (unsigned char)(i * 11 + 5);
    buf[3] = 42;
    buf[33] = 99;
    uint8x16x4_t r = vld4q_u8(buf);
    for (k = 0; k < 4; ++k)
        for (j = 0; j < 16; ++j)
            ZASSERT(r.val[k][j] == buf[4 * j + k]);
    ZASSERT(r.val[3][0] == 42);
    ZASSERT(r.val[1][8] == 99);
    /* And a multi-vector store mixed back in with scalar loads. */
    uint8x16x2_t x;
    for (k = 0; k < 2; ++k)
        for (j = 0; j < 16; ++j)
            x.val[k][j] = (unsigned char)(k * 10 + j + 1);
    vst2q_u8(buf + 32, x);
    for (k = 0; k < 2; ++k)
        for (j = 0; j < 16; ++j)
            ZASSERT(buf[32 + 2 * j + k] == (unsigned char)(k * 10 + j + 1));
    ZASSERT(buf[32] == 1);
    ZASSERT(buf[63] == 26);
    for (i = 0; i < 32; ++i)
        ZASSERT(buf[i] == (unsigned char)(i == 3 ? 42 : (i * 11 + 5)));
    zprintf("neon scalar plus mv test passed!\n");
    return 0;
}
