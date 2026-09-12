#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    char buf[47];
    unsigned i;
    for (i = 0; i < 47; ++i)
        buf[i] = (char)(i * 5 + 1);
    /* 40 + 48 bytes exceeds the 47-byte (rounded to 48) stack object. */
    uint8x16x3_t r = vld3q_u8((unsigned char*)buf + 40);
    ZASSERT(r.val[0][0] == (unsigned char)buf[40]);
    zprintf("Should have failed!\n");
    return 0;
}
