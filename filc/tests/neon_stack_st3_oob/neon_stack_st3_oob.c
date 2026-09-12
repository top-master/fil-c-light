#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

/* The identity keeps the optimizer from proving that the multi-vector store
   writes out of bounds of the array (which would let it delete the store as
   undefined behavior before the pizlonator sees it). */
static __attribute__((noinline)) unsigned char* identity(unsigned char* p)
{
    return p;
}

int main(void)
{
    char buf[64];
    unsigned i, k, j;
    for (i = 0; i < 64; ++i)
        buf[i] = (char)(i * 11 + 7);
    uint8x16x3_t x;
    for (k = 0; k < 3; ++k)
        for (j = 0; j < 16; ++j)
            x.val[k][j] = (unsigned char)(k * 10 + j + 1);
    /* 32 + 48 bytes exceeds the 64-byte stack object. */
    vst3q_u8(identity((unsigned char*)buf) + 32, x);
    zprintf("Should have failed!\n");
    return 0;
}
