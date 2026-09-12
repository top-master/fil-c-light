#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* src = opaque(malloc(32));
    unsigned char* dst = opaque(malloc(32));
    unsigned i;
    for (i = 0; i < 32; ++i)
        src[i] = (unsigned char)(i * 29 + 11);
    uint8x16x2_t r = vld2q_u8(src);
    vst2q_u8(dst, r);
    ZASSERT(!memcmp(src, dst, 32));
    zprintf("neon roundtrip ld2 st2 test passed!\n");
    return 0;
}
