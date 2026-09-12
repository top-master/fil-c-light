#include <stdio.h>
#include <stdlib.h>

void xchg_pairs(unsigned long* in, unsigned long* out);

int main()
{
    /* xchg reg,reg must swap BOTH values (both operands are read and written),
       in both operand orders, under register pressure that forces the two
       exchanged webs into different colors. */
    unsigned long* in = malloc(64);
    unsigned long* out = malloc(128);
    if (!in || !out)
        return 1;
    in[0] = 0x1111111111111111UL;
    in[1] = 0x2222222222222222UL;
    in[2] = 0x3333333333333333UL;
    in[3] = 0x4444444444444444UL;
    xchg_pairs(in, out);
    if (out[0] != in[1] || out[1] != in[0]) {
        printf("xchg pair1 out0=%lx out1=%lx\n", out[0], out[1]);
        return 1;
    }
    if (out[2] != in[3] || out[3] != in[2]) {
        printf("xchg pair2 out2=%lx out3=%lx\n", out[2], out[3]);
        return 1;
    }
    if (out[4] != 0x5555555555555555UL || out[5] != 0x6666666666666666UL
        || out[6] != 0x7777777777777777UL || out[7] != 0x8888888888888888UL) {
        printf("xchg pressure registers clobbered\n");
        return 1;
    }
    printf("xchg att ok\n");
    return 0;
}
