#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    /* Exact-fit 8-byte allocation: the replicate load touches exactly 8 bytes. */
    unsigned char* buf = opaque(malloc(8));
    float a = 1.5f, b = -2.25f;
    memcpy(buf, &a, 4);
    memcpy(buf + 4, &b, 4);
    float32x4x2_t r = vld2q_dup_f32((float*)buf);
    unsigned j;
    for (j = 0; j < 4; ++j) {
        ZASSERT(r.val[0][j] == a);
        ZASSERT(r.val[1][j] == b);
    }
    zprintf("neon ld2q dup f32 exact test passed!\n");
    return 0;
}
