#include <stdio.h>
#include <stdlib.h>
#include <string.h>

long avx512_test(void* in, void* out);

int main()
{
    /* 68-byte input: 16 floats at [0,64) plus one broadcast element at [64,68).
       The {1to16} load must be checked at element width (4 bytes at offset 64);
       a full 64-byte check there would trap. */
    float* in = malloc(68);
    float* out = malloc(128);
    if (!in || !out)
        return 1;
    int i;
    for (i = 0; i < 16; i++)
        in[i] = 1.0f;
    in[16] = 1.0f;
    memset(out, 0, 128);
    long r = avx512_test(in, out);
    for (i = 0; i < 16; i++) {
        if (out[i] != 3.0f)
            return 1;
    }
    for (i = 16; i < 32; i++) {
        float expect = (i == 19) ? 3.0f : 0.0f;
        if (out[i] != expect)
            return 1;
    }
    if (r != 61440)   /* 0xFF00 & 0xF0F0 = 0xF000 */
        return 1;
    printf("avx512 61440 ok\n");
    return 0;
}
