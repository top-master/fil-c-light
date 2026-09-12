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
    free(buf);
    buf = opaque(buf);
    uint32x4x2_t x;
    unsigned k, j;
    for (k = 0; k < 2; ++k)
        for (j = 0; j < 4; ++j)
            x.val[k][j] = (uint32_t)(k * 10 + j + 1);
    vst2q_u32(buf + 16, x);
    zprintf("Should have failed!\n");
    return 0;
}
