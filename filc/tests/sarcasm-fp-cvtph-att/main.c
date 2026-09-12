#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void ps2ph(const void* in, void* out);
void ph2ps(const void* in, void* out);

int main()
{
    /* Round-trip 8 floats that are exactly representable in half precision
       through ps -> ph -> ps and expect bit-exact results. */
    static const float vals[8] = {1.0f, 2.5f, -4.0f, 0.5f, 3.0f, -1.5f, 100.0f, 0.25f};
    float* in = malloc(32);
    char* half = malloc(16);   /* the 16-byte ps2ph store must fit exactly */
    float* out = malloc(32);
    if (!in || !half || !out)
        return 1;
    memcpy(in, vals, 32);
    memset(half, 0xAA, 16);
    memset(out, 0, 32);
    ps2ph(in, half);
    ph2ps(half, out);
    int i;
    for (i = 0; i < 8; i++) {
        if (out[i] != vals[i]) {
            printf("lane %d: got %f want %f\n", i, out[i], vals[i]);
            return 1;
        }
    }
    printf("cvtph ok\n");
    return 0;
}
