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
    uint64x2x2_t x;
    unsigned k, j;
    for (k = 0; k < 2; ++k)
        for (j = 0; j < 2; ++j)
            x.val[k][j] = 0x100000000ull * (k + 1) + j;
    vst2q_u64((uint64_t*)buf + 2, x);
    for (i = 0; i < 16; ++i)
        ZASSERT(buf[i] == (unsigned char)(i * 13 + 7));
    for (k = 0; k < 2; ++k)
        for (j = 0; j < 2; ++j)
            ZASSERT(*(uint64_t*)(void*)(buf + 16 + 8 * (2 * j + k)) == 0x100000000ull * (k + 1) + j);
    for (i = 48; i < 64; ++i)
        ZASSERT(buf[i] == (unsigned char)(i * 13 + 7));
    zprintf("neon st2q u64 test passed!\n");
    return 0;
}
