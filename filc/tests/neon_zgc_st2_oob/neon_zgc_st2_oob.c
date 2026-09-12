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
    uint8x16x2_t x;
    unsigned k, j;
    for (k = 0; k < 2; ++k)
        for (j = 0; j < 16; ++j)
            x.val[k][j] = (unsigned char)(k * 10 + j + 1);
    /* One-byte overrun: 63 + 32 bytes exceeds the 64-byte object. */
    vst2q_u8(buf + 63, x);
    zprintf("Should have failed!\n");
    return 0;
}
