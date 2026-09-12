#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* src = opaque(malloc(48));
    unsigned char* dst = opaque(malloc(48));
    unsigned i, k, j;
    for (i = 0; i < 48; ++i)
        src[i] = (unsigned char)(i * 29 + 11);
    /* De-interleave with vld3 and re-interleave with scalar stores, then
       compare against a pure scalar de-interleave/interleave roundtrip. */
    uint16x8x3_t r = vld3q_u16((uint16_t*)src);
    for (k = 0; k < 3; ++k)
        for (j = 0; j < 8; ++j) {
            uint16_t e;
            __builtin_memcpy(&e, src + 2 * (3 * j + k), 2);
            ZASSERT(r.val[k][j] == e);
        }
    for (k = 0; k < 3; ++k)
        for (j = 0; j < 8; ++j) {
            uint16_t tmp = r.val[k][j];
            memcpy(dst + 2 * (3 * j + k), &tmp, 2);
        }
    ZASSERT(!memcmp(src, dst, 48));
    zprintf("neon roundtrip interleave test passed!\n");
    return 0;
}
