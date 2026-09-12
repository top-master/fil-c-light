#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(96));
    unsigned char out[96];
    unsigned i, k, j;
    for (i = 0; i < 96; ++i)
        buf[i] = (unsigned char)(i * 5 + 3);
    for (i = 0; i < 96; i += 32) {
        uint8x16x2_t r = vld2q_u8(buf + i);
        for (k = 0; k < 2; ++k)
            for (j = 0; j < 16; ++j)
                out[i + 2 * j + k] = r.val[k][j];
    }
    ZASSERT(!memcmp(out, buf, 96));
    zprintf("neon loop chunked test passed!\n");
    return 0;
}
