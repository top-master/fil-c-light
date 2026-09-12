#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

static __attribute__((noinline)) void do_st3(unsigned char* p)
{
    uint8x16x3_t x;
    unsigned k, j;
    for (k = 0; k < 3; ++k)
        for (j = 0; j < 16; ++j)
            x.val[k][j] = (unsigned char)(k * 10 + j + 1);
    vst3q_u8(p, x);
}

int main(void)
{
    unsigned char* buf = opaque(malloc(48));
    unsigned i;
    for (i = 0; i < 48; ++i)
        buf[i] = (unsigned char)(i * 9 + 1);
    do_st3(buf + 1);
    zprintf("Should have failed!\n");
    return 0;
}
