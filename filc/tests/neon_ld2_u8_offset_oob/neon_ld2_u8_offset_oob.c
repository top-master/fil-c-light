#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(40));
    unsigned i;
        for (i = 0; i < 40; ++i)
        buf[i] = (unsigned char)(i * 7 + 3);
    uint8x16x2_t r = vld2q_u8(buf + 17);
    ZASSERT(r.val[1][15] == 0x2a);

    zprintf("Should have failed!\n");
    return 0;
}
