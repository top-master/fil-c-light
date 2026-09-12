#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(48));
    unsigned i;
        for (i = 0; i < 48; ++i)
        buf[i] = (unsigned char)(i * 7 + 3);
    uint8x16x4_t r = vld4q_u8(buf);
    ZASSERT(r.val[3][15] == 0x2a);

    zprintf("Should have failed!\n");
    return 0;
}
