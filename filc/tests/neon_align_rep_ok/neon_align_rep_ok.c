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
    /* Element-unit replicate forms with int elements do not check alignment.
       This intentionally succeeds even though buf + 1 is not 4-aligned. */
    uint32x4x2_t r = vld2q_dup_u32(buf + 1);
    uint32_t a, b;
    __builtin_memcpy(&a, buf + 1, 4);
    __builtin_memcpy(&b, buf + 5, 4);
    unsigned j;
    for (j = 0; j < 4; ++j) {
        ZASSERT(r.val[0][j] == a);
        ZASSERT(r.val[1][j] == b);
    }
    zprintf("neon align rep ok test passed!\n");
    return 0;
}
