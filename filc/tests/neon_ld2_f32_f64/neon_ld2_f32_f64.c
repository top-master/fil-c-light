#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(64));
    unsigned i;
    for (i = 0; i < 8; ++i)
        ((float*)buf)[i] = (float)i * 1.5f + 1.f;
    for (i = 0; i < 4; ++i)
        ((double*)(buf + 32))[i] = (double)i * 2.5 + 1.;
    float32x4x2_t r = vld2q_f32((float*)buf);
    for (i = 0; i < 4; ++i) {
        ZASSERT(r.val[0][i] == ((float*)buf)[2 * i]);
        ZASSERT(r.val[1][i] == ((float*)buf)[2 * i + 1]);
    }
    float64x2x2_t r2 = vld2q_f64((double*)(buf + 32));
    for (i = 0; i < 2; ++i) {
        ZASSERT(r2.val[0][i] == ((double*)(buf + 32))[2 * i]);
        ZASSERT(r2.val[1][i] == ((double*)(buf + 32))[2 * i + 1]);
    }
    zprintf("neon ld2 f32 f64 test passed!\n");

    return 0;
}
