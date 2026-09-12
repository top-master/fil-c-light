#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(96));
    unsigned i, k, j;
    for (i = 0; i < 96; ++i)
        buf[i] = (unsigned char)(i * 13 + 7);
    float32x4x4_t x;
    for (k = 0; k < 4; ++k)
        for (j = 0; j < 4; ++j)
            x.val[k][j] = (float)(k * 10 + j) + 0.5f;
    vst4q_f32((float*)buf + 8, x);
    for (k = 0; k < 4; ++k)
        for (j = 0; j < 4; ++j) {
            float e = (float)(k * 10 + j) + 0.5f;
            ZASSERT(*(float*)(void*)(buf + 32 + 4 * (4 * j + k)) == e);
        }
    for (i = 0; i < 32; ++i)
        ZASSERT(buf[i] == (unsigned char)(i * 13 + 7));
    zprintf("neon st4q f32 test passed!\n");
    return 0;
}
