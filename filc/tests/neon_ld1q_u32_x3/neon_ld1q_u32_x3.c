#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(96));
    unsigned i;
    for (i = 0; i < 96; ++i)
        buf[i] = (unsigned char)(i * 13 + 7);
    uint32x4x3_t r = vld1q_u32_x3((uint32_t*)buf);
    unsigned k, j;
    for (k = 0; k < 3; ++k)
        for (j = 0; j < 4; ++j) {
            uint32_t e;
            __builtin_memcpy(&e, buf + 16 * k + 4 * j, 4);
            ZASSERT(r.val[k][j] == e);
        }
    zprintf("neon ld1q u32 x3 test passed!\n");
    return 0;
}
