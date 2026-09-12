#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(64));
    unsigned i;
    for (i = 0; i < 64; ++i)
        buf[i] = (unsigned char)(i * 37 + 200);
    int8x16x2_t r = vld2q_s8((int8_t*)buf);
    unsigned j;
    for (j = 0; j < 16; ++j) {
        ZASSERT(r.val[0][j] == (int8_t)(unsigned char)(buf[2 * j]));
        ZASSERT(r.val[1][j] == (int8_t)(unsigned char)(buf[2 * j + 1]));
    }
    zprintf("neon ld2q s8 test passed!\n");
    return 0;
}
