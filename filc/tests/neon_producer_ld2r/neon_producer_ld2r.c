#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

static __attribute__((noinline)) unsigned char* make_buffer(unsigned n)
{
    unsigned char* buf = opaque(malloc(n));
    unsigned i;
    for (i = 0; i < n; ++i)
        buf[i] = (unsigned char)(i * 31 + 17);
    return buf;
}

int main(void)
{
    unsigned char* buf = make_buffer(64);
    unsigned i;
    for (i = 0; i < 8; ++i) {
        uint32x4x2_t r = vld2q_dup_u32(buf + 8 * i);
        ZASSERT(r.val[0][0] == *(uint32_t*)(void*)(buf + 8 * i));
        ZASSERT(r.val[1][0] == *(uint32_t*)(void*)(buf + 8 * i + 4));
        for (unsigned j = 0; j < 4; ++j) {
            ZASSERT(r.val[0][j] == *(uint32_t*)(void*)(buf + 8 * i));
            ZASSERT(r.val[1][j] == *(uint32_t*)(void*)(buf + 8 * i + 4));
        }
    }
    zprintf("neon producer ld2r test passed!\n");
    return 0;
}
