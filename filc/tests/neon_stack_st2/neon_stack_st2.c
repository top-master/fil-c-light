#include <arm_neon.h>
#include <stdint.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    char buf[64];
    unsigned i, k, j;
    for (i = 0; i < 64; ++i)
        buf[i] = (char)(i * 11 + 7);
    uint16x8x2_t x;
    for (k = 0; k < 2; ++k)
        for (j = 0; j < 8; ++j)
            x.val[k][j] = (uint16_t)(1000 + k * 10 + j);
    vst2q_u16((unsigned char*)buf + 16, x);
    for (k = 0; k < 2; ++k)
        for (j = 0; j < 8; ++j)
            ZASSERT(*(uint16_t*)(void*)(buf + 16 + 2 * (2 * j + k)) == (uint16_t)(1000 + k * 10 + j));
    for (i = 0; i < 16; ++i)
        ZASSERT((unsigned char)buf[i] == (unsigned char)(i * 11 + 7));
    for (i = 48; i < 64; ++i)
        ZASSERT((unsigned char)buf[i] == (unsigned char)(i * 11 + 7));
    zprintf("neon stack st2 test passed!\n");
    return 0;
}
