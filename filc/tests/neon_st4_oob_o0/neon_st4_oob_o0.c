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
    uint8x16x4_t x;
    unsigned k, j;
    for (k = 0; k < 4; ++k)
        for (j = 0; j < 16; ++j)
            x.val[k][j] = (unsigned char)(k * 10 + j + 1);
    vst4q_u8(buf + 1, x);
    zprintf("Should have failed!\n");
    return 0;
}
