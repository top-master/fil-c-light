#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(zgc_alloc(64));
    unsigned i;
    for (i = 0; i < 64; ++i)
        buf[i] = (unsigned char)(i * 3 + 9);
    uint8x16x4_t r = vld4q_u8(buf);
    unsigned k, j;
    for (k = 0; k < 4; ++k)
        for (j = 0; j < 16; ++j)
            ZASSERT(r.val[k][j] == buf[4 * j + k]);
    zprintf("neon zgc ld4 test passed!\n");
    return 0;
}
