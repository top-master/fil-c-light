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
    /* Offset so big that it does not fit in a signed 32-bit int. */
    uint8x16x3_t r = vld3q_u8(buf + 0x180000000u);
    ZASSERT(r.val[0][0] == buf[0]);
    zprintf("Should have failed!\n");
    return 0;
}
