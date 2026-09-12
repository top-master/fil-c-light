#include <stdio.h>
#include <stdlib.h>

long bcast_zmm(float* out, const float* in);
long bcast_xmm(float* out, const float* in);

int main()
{
    /* zmm {1to16}: out[i] must equal in[i] + 1.5f for ALL 16 lanes. */
    float* in = malloc(64);
    float* out = malloc(64);
    if (!in || !out)
        return 1;
    int i;
    for (i = 0; i < 16; i++) {
        in[i] = (float)(i * 3);
        out[i] = -999.0f;
    }
    bcast_zmm(out, in);
    for (i = 0; i < 16; i++) {
        if (out[i] != (float)(i * 3) + 1.5f) {
            printf("zmm lane %d: got %f want %f\n", i, out[i], (float)(i * 3) + 1.5f);
            return 1;
        }
    }
    /* xmm {1to4}: out[i] must equal in2[i] + 2.5f for all 4 lanes. */
    float* in2 = malloc(16);
    float* out2 = malloc(16);
    if (!in2 || !out2)
        return 1;
    for (i = 0; i < 4; i++) {
        in2[i] = (float)(i * 10);
        out2[i] = -999.0f;
    }
    bcast_xmm(out2, in2);
    for (i = 0; i < 4; i++) {
        if (out2[i] != (float)(i * 10) + 2.5f) {
            printf("xmm lane %d: got %f want %f\n", i, out2[i], (float)(i * 10) + 2.5f);
            return 1;
        }
    }
    printf("bcast-stack ok\n");
    return 0;
}
