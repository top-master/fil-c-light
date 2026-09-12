#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void cvt_narrow_x_att(void* in, void* out);
void cvt_narrow_y_att(void* in, void* out);
void cvt_narrow_z_att(void* in, void* out);
void cvt_narrow_xmm_int(void* in, void* out);

int main()
{
    /* All input objects are sized so the checked load fills the object
       exactly: an over-wide width model would trap, and the converted
       values prove the load happened at all. */

    /* vcvtpd2psx (AT&T): 16-byte source, 2 doubles -> 2 floats. */
    double* in16 = malloc(16);
    float* out4 = malloc(16);
    if (!in16 || !out4)
        return 1;
    in16[0] = 1.5;
    in16[1] = -2.25;
    memset(out4, 0, 16);
    cvt_narrow_x_att(in16, out4);
    if (out4[0] != 1.5f || out4[1] != -2.25f || out4[2] != 0.0f || out4[3] != 0.0f) {
        printf("cvt x: %f %f %f %f\n", out4[0], out4[1], out4[2], out4[3]);
        return 1;
    }

    /* vcvtpd2ps xmm0, XMMWORD PTR [rdi] (Intel): same shape. */
    memset(out4, 0, 16);
    cvt_narrow_xmm_int(in16, out4);
    if (out4[0] != 1.5f || out4[1] != -2.25f || out4[2] != 0.0f || out4[3] != 0.0f) {
        printf("cvt int: %f %f %f %f\n", out4[0], out4[1], out4[2], out4[3]);
        return 1;
    }

    /* vcvtpd2psy (AT&T): 32-byte source, 4 doubles -> 4 floats. */
    double* in32 = malloc(32);
    if (!in32)
        return 1;
    in32[0] = 3.25;
    in32[1] = -4.5;
    in32[2] = 5.75;
    in32[3] = -6.875;
    memset(out4, 0, 16);
    cvt_narrow_y_att(in32, out4);
    if (out4[0] != 3.25f || out4[1] != -4.5f || out4[2] != 5.75f || out4[3] != -6.875f) {
        printf("cvt y: %f %f %f %f\n", out4[0], out4[1], out4[2], out4[3]);
        return 1;
    }

    /* Bare vcvtpd2ps (%rdi), %ymm0: unambiguous m512 source, 64 bytes. */
    double* in64 = malloc(64);
    float* out8 = malloc(32);
    if (!in64 || !out8)
        return 1;
    int i;
    for (i = 0; i < 8; i++)
        in64[i] = (i % 2 ? -1.0 : 1.0) * (i + 1) * 0.5;
    memset(out8, 0, 32);
    cvt_narrow_z_att(in64, out8);
    for (i = 0; i < 8; i++) {
        float expect = (float)((i % 2 ? -1.0 : 1.0) * (i + 1) * 0.5);
        if (out8[i] != expect) {
            printf("cvt z: out8[%d]=%f want %f\n", i, out8[i], expect);
            return 1;
        }
    }

    printf("cvt narrow ok\n");
    return 0;
}
