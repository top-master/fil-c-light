#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(32));
    unsigned i;
    for (i = 0; i < 32; ++i)
        buf[i] = (unsigned char)(i * 7 + 3);
    uint8x16x2_t r = vld2q_u8(buf + 31);
    ZASSERT(r.val[0][0] == buf[31]);
    zprintf("Should have failed!\n");
    return 0;
}
