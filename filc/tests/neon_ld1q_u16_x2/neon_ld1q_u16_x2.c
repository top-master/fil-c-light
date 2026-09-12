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
        buf[i] = (unsigned char)(i * 13 + 7);
    uint16x8x2_t r = vld1q_u16_x2((uint16_t*)buf);
    unsigned k, j;
    for (k = 0; k < 2; ++k)
        for (j = 0; j < 8; ++j) {
            uint16_t e;
            __builtin_memcpy(&e, buf + 16 * k + 2 * j, 2);
            ZASSERT(r.val[k][j] == e);
        }
    zprintf("neon ld1q u16 x2 test passed!\n");
    return 0;
}
