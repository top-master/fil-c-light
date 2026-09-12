#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(16));
    buf[15] = 0x12;
    uint8x16x2_t r = vld2q_dup_u8(buf + 15);
    ZASSERT(r.val[1][0] == 0x12);

    zprintf("Should have failed!\n");
    return 0;
}
