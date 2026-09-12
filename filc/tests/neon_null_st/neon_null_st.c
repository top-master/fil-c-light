#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

static __attribute__((noinline)) void* get_null(void)
{
    return 0;
}

int main(void)
{
    unsigned char* p = opaque(get_null());
    uint8x16x2_t x;
    unsigned k, j;
    for (k = 0; k < 2; ++k)
        for (j = 0; j < 16; ++j)
            x.val[k][j] = (unsigned char)(k * 10 + j + 1);
    vst2q_u8(p, x);
    zprintf("Should have failed!\n");
    return 0;
}
