#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(zgc_aligned_alloc(64, 64));
    unsigned i;
    for (i = 0; i < 64; ++i)
        buf[i] = (unsigned char)(i * 3 + 9);
    uint8x16x2_t x;
    unsigned k, j;
    for (k = 0; k < 2; ++k)
        for (j = 0; j < 16; ++j)
            x.val[k][j] = (unsigned char)(200 + k * 10 + j);
    vst1q_u8_x2(buf + 32, x);
    for (i = 0; i < 32; ++i)
        ZASSERT(buf[i] == (unsigned char)(i * 3 + 9));
    for (k = 0; k < 2; ++k)
        for (j = 0; j < 16; ++j)
            ZASSERT(buf[32 + 16 * k + j] == (unsigned char)(200 + k * 10 + j));
    zprintf("neon zgc aligned st1x2 test passed!\n");
    return 0;
}
