#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* src = opaque(malloc(64));
    unsigned char* dst = opaque(malloc(64));
    unsigned i;
    for (i = 0; i < 64; ++i)
        src[i] = (unsigned char)(i * 29 + 11);
    uint8x16x4_t r = vld4q_u8(src);
    vst4q_u8(dst, r);
    ZASSERT(!memcmp(src, dst, 64));
    zprintf("neon roundtrip ld4 st4 test passed!\n");
    return 0;
}
