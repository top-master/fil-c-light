#include <stdio.h>
#include <stdlib.h>
#include <string.h>

long idiv_stress(long* in, long* out);
void div_uq(unsigned long* io);
void idiv_l(int* io);
void mul_q(unsigned long* io);
void imul_1op(long* io);
void idiv_mem(long* io, long* divisor_obj);
void sext_bw(unsigned char* io);

int main()
{
    /* Signed 64-bit idiv under register pressure: quotient AND remainder. */
    long* in = malloc(16);
    long* out = malloc(16);
    if (!in || !out)
        return 1;
    long D = -861330324987697221L;
    long S = 1234567891234L;
    in[0] = D;
    in[1] = S;
    long checksum = idiv_stress(in, out);
    if (out[0] != D / S || out[1] != D % S) {
        printf("idiv_stress q=%ld r=%ld want q=%ld r=%ld\n", out[0], out[1], D / S, D % S);
        return 1;
    }
    if (checksum != 11 + 22 + 33 + 44 + 55) {
        printf("idiv_stress checksum %ld\n", checksum);
        return 1;
    }

    /* Unsigned divq. */
    unsigned long* uio = malloc(32);
    if (!uio)
        return 1;
    uio[0] = 0xFEDCBA9876543210UL;
    uio[1] = 0x123456789AUL;
    div_uq(uio);
    if (uio[2] != uio[0] / uio[1] || uio[3] != uio[0] % uio[1]) {
        printf("div_uq q=%lu r=%lu\n", uio[2], uio[3]);
        return 1;
    }

    /* 32-bit idivl with cltd. */
    int* iio = malloc(16);
    if (!iio)
        return 1;
    iio[0] = -2000000000;
    iio[1] = 7;
    idiv_l(iio);
    if (iio[2] != iio[0] / iio[1] || iio[3] != iio[0] % iio[1]) {
        printf("idiv_l q=%d r=%d\n", iio[2], iio[3]);
        return 1;
    }

    /* mulq: 128-bit unsigned product, both halves. */
    unsigned long* mio = malloc(32);
    if (!mio)
        return 1;
    mio[0] = 0xFFFFFFFFFFFFFFFFUL;
    mio[1] = 0x0123456789ABCDEFUL;
    mul_q(mio);
    unsigned __int128 uprod = (unsigned __int128)mio[0] * mio[1];
    if (mio[2] != (unsigned long)uprod || mio[3] != (unsigned long)(uprod >> 64)) {
        printf("mul_q lo=%lu hi=%lu\n", mio[2], mio[3]);
        return 1;
    }

    /* 1-operand imulq: 128-bit signed product, both halves. */
    long* sio = malloc(32);
    if (!sio)
        return 1;
    sio[0] = -0x0123456789ABCDEFL;
    sio[1] = 0x0FEDCBA987654321L;
    imul_1op(sio);
    __int128 sprod = (__int128)sio[0] * sio[1];
    if (sio[2] != (long)sprod || sio[3] != (long)(sprod >> 64)) {
        printf("imul_1op lo=%ld hi=%ld\n", sio[2], sio[3]);
        return 1;
    }

    /* Memory-form idivq: divisor lives in the LAST 8 bytes of a 16-byte
       object; an over-wide check would have trapped. */
    long* io = malloc(32);
    long* dobj = malloc(16);
    if (!io || !dobj)
        return 1;
    io[0] = -5000000000000L;
    dobj[1] = -98765L;
    idiv_mem(io, dobj);
    if (io[1] != io[0] / dobj[1] || io[2] != io[0] % dobj[1]) {
        printf("idiv_mem q=%ld r=%ld\n", io[1], io[2]);
        return 1;
    }

    /* cbw/cwde sign extension: 0x80 -> -128. */
    unsigned char* b = malloc(16);
    if (!b)
        return 1;
    memset(b, 0, 16);
    b[0] = 0x80;
    sext_bw(b);
    int se;
    memcpy(&se, b + 4, 4);
    if (se != -128) {
        printf("sext_bw %d\n", se);
        return 1;
    }

    printf("div att ok\n");
    return 0;
}
