#include <stdio.h>
#include <stdlib.h>
#include <string.h>

long avx2_arith(void* in, void* out);

int main()
{
    /* 4-byte input: a 64-byte (full-vector) check on the vbroadcastss load
       would trap on this small object; the 4-byte check must pass. */
    float* in = malloc(4);
    float* out = malloc(32);
    if (!in || !out)
        return 1;
    *in = 1.5f;
    memset(out, 0, 32);
    long r = avx2_arith(in, out);
    int i;
    for (i = 0; i < 8; i++) {
        if (out[i] != 9.0f)
            return 1;
    }
    if (r != 18)
        return 1;
    printf("avx2 18 ok\n");
    return 0;
}
