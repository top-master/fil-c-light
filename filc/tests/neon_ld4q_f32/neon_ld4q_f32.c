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
        buf[i] = (unsigned char)(i * 13 + 7);
    float32x4x4_t r = vld4q_f32((float*)buf);
    unsigned k, j;
    for (k = 0; k < 4; ++k)
        for (j = 0; j < 4; ++j) {
            float e;
            __builtin_memcpy(&e, buf + 4 * (4 * j + k), 4);
            ZASSERT(r.val[k][j] == e);
        }
    zprintf("neon ld4q f32 test passed!\n");
    return 0;
}
