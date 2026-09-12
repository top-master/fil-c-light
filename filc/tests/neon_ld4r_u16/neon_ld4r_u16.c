#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(8));
    unsigned i;
    unsigned k;
    for (k = 0; k < 4; ++k)
        ((uint16_t*)buf)[k] = (uint16_t)(0x1111 * (k + 1) + 7);
    uint16x8x4_t r = vld4q_dup_u16((uint16_t*)buf);
    for (i = 0; i < 8; ++i) {
        for (k = 0; k < 4; ++k)
            ZASSERT(r.val[k][i] == ((uint16_t*)buf)[k]);
    }
    zprintf("neon ld4r u16 test passed!\n");

    return 0;
}
