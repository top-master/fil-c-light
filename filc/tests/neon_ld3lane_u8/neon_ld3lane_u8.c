#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(3));
    unsigned i;
    unsigned k;
    buf[0] = 0x5a;
    buf[1] = 0xa5;
    buf[2] = 0x3c;
    uint8x8x3_t src;
    src.val[0] = vdup_n_u8(0x11);
    src.val[1] = vdup_n_u8(0x22);
    src.val[2] = vdup_n_u8(0x33);
    uint8x8x3_t r = vld3_lane_u8(buf, src, 2);
    for (i = 0; i < 8; ++i) {
        for (k = 0; k < 3; ++k) {
            if (i == 2)
                ZASSERT(r.val[k][i] == buf[k]);
            else
                ZASSERT(r.val[k][i] == (unsigned char)(0x11 * (k + 1)));
        }
    }
    zprintf("neon ld3lane u8 test passed!\n");

    return 0;
}
