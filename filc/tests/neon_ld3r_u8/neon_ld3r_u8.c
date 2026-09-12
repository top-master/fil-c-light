#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(3));
    unsigned i;
    unsigned k;
    buf[0] = 0x11;
    buf[1] = 0x22;
    buf[2] = 0x33;
    uint8x16x3_t r = vld3q_dup_u8(buf);
    for (i = 0; i < 16; ++i) {
        for (k = 0; k < 3; ++k)
            ZASSERT(r.val[k][i] == buf[k]);
    }
    zprintf("neon ld3r u8 test passed!\n");

    return 0;
}
