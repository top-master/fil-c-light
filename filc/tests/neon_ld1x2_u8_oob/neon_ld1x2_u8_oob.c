#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(16));
    unsigned i;
        for (i = 0; i < 16; ++i)
        buf[i] = (unsigned char)(i * 7 + 3);
    uint8x16x2_t r = vld1q_u8_x2(buf);
    ZASSERT(r.val[1][15] == 0x2a);

    zprintf("Should have failed!\n");
    return 0;
}
