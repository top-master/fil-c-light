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
        buf[i] = (unsigned char)(i * 7 + 3);
    uint16x8x2_t x;
    unsigned k, j;
    for (k = 0; k < 2; ++k)
        for (j = 0; j < 8; ++j)
            x.val[k][j] = (uint16_t)(k * 10 + j + 1);
    vst2q_u16(buf + 0x10000000u, x);
    zprintf("Should have failed!\n");
    return 0;
}
