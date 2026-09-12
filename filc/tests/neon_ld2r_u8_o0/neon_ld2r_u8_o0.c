#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(2));
    unsigned i;
    buf[0] = 0x5a;
    buf[1] = 0xa5;
    uint8x16x2_t r = vld2q_dup_u8(buf);
    for (i = 0; i < 16; ++i) {
        ZASSERT(r.val[0][i] == 0x5a);
        ZASSERT(r.val[1][i] == 0xa5);
    }
    zprintf("neon ld2r u8 o0 test passed!\n");

    return 0;
}
