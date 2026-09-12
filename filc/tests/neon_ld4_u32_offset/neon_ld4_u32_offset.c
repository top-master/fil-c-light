#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(80));
    unsigned i;
    unsigned k;
    for (i = 0; i < 20; ++i)
        ((uint32_t*)buf)[i] = (uint32_t)(i * 100003 + 17);
    uint32x4x4_t r = vld4q_u32((uint32_t*)(buf + 16));
    for (i = 0; i < 4; ++i) {
        for (k = 0; k < 4; ++k)
            ZASSERT(r.val[k][i] == ((uint32_t*)buf)[4 + 4 * i + k]);
    }
    zprintf("neon ld4 u32 offset test passed!\n");

    return 0;
}
