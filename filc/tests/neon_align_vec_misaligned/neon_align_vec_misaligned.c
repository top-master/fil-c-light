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
    /* Vector-unit forms require element-size alignment: 2 is not 4-aligned. */
    uint32x4x2_t r = vld2q_u32(buf + 2);
    ZASSERT(r.val[0][0] == 0);
    zprintf("Should have failed!\n");
    return 0;
}
