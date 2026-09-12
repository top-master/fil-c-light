#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void ps2ph512(const void* in, void* out);
void ph2ps512(const void* in, void* out);

int main()
{
    /* Round-trip 16 half-exact floats through zmm ps -> ph -> ps. */
    static const float vals[16] = {1.0f, 2.5f, -4.0f, 0.5f, 3.0f, -1.5f, 100.0f, 0.25f,
                                   -0.0f, 16.0f, -32.0f, 0.125f, 7.0f, -9.5f, 255.0f, 1.5f};
    float* in = malloc(64);
    char* half = malloc(32);   /* the 32-byte ps2ph store must fit exactly */
    float* out = malloc(64);
    if (!in || !half || !out)
        return 1;
    memcpy(in, vals, 64);
    memset(half, 0xAA, 32);
    memset(out, 0, 64);
    ps2ph512(in, half);
    ph2ps512(half, out);
    int i;
    for (i = 0; i < 16; i++) {
        if (out[i] != vals[i]) {
            printf("lane %d: got %f want %f\n", i, out[i], vals[i]);
            return 1;
        }
    }
    printf("cvtph512 ok\n");
    return 0;
}
