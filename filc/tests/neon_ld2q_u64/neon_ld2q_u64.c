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
    uint64x2x2_t r = vld2q_u64((uint64_t*)buf);
    unsigned j;
    for (j = 0; j < 2; ++j) {
        uint64_t a, b;
        __builtin_memcpy(&a, buf + 16 * j, 8);
        __builtin_memcpy(&b, buf + 16 * j + 8, 8);
        ZASSERT(r.val[0][j] == a);
        ZASSERT(r.val[1][j] == b);
    }
    zprintf("neon ld2q u64 test passed!\n");
    return 0;
}
