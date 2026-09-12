#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(16));
    unsigned k;
    for (k = 0; k < 8; ++k)
        ((uint16_t*)buf)[k] = (uint16_t)(k * 4369 + 7);
    uint16x8x3_t r = vld3q_dup_u16((uint16_t*)(buf + 11));
    ZASSERT(r.val[2][0] == 0x1234);

    zprintf("Should have failed!\n");
    return 0;
}
