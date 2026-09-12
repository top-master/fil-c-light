#include <stdfil.h>
#include <arm_neon.h>
#include <stdint.h>

/* Saturation helpers matching SignedSatQ/UnsignedSatQ. */
static int16_t sat16(int32_t x)
{
    if (x > INT16_MAX) return INT16_MAX;
    if (x < INT16_MIN) return INT16_MIN;
    return (int16_t)x;
}

static int8_t sat8(int32_t x)
{
    if (x > INT8_MAX) return INT8_MAX;
    if (x < INT8_MIN) return INT8_MIN;
    return (int8_t)x;
}

static uint8_t usat8(int32_t x)
{
    if (x > 255) return 255;
    if (x < 0) return 0;
    return (uint8_t)x;
}

static uint16_t usat16(int64_t x)
{
    if (x > 65535) return 65535;
    if (x < 0) return 0;
    return (uint16_t)x;
}

int main(void)
{
    /* sqshl: signed saturating left shift by immediate, .8h. */
    int16x8_t a = {0x4000, -0x4000, 0x1234, -1, 100, 200, -200, 5};
    int16x8_t r;
    asm volatile("sqshl %0.8h, %1.8h, #1" : "=w"(r) : "w"(a));
    ZASSERT(r[0] == INT16_MAX); /* 0x4000 << 1 saturates */
    ZASSERT(r[1] == -0x8000);   /* fits exactly */
    ZASSERT(r[2] == 0x2468);
    ZASSERT(r[3] == -2);
    ZASSERT(r[7] == 10);

    /* uqshl: unsigned saturating left shift, .8h. */
    uint16x8_t ua = {0x8000, 0x7FFF, 0x0100, 5, 100, 200, 300, 400};
    uint16x8_t ur;
    asm volatile("uqshl %0.8h, %1.8h, #1" : "=w"(ur) : "w"(ua));
    ZASSERT(ur[0] == 0xFFFFU); /* saturates */
    ZASSERT(ur[1] == 0xFFFEU);
    ZASSERT(ur[2] == 0x0200U);
    ZASSERT(ur[3] == 10U);

    /* sqshl register form, .4s. */
    int32x4_t ra = {1, -1, 0x40000000, 7};
    int32x4_t sh = {2, 2, 1, 3};
    int32x4_t rr;
    asm volatile("sqshl %0.4s, %1.4s, %2.4s" : "=w"(rr) : "w"(ra), "w"(sh));
    ZASSERT(rr[0] == 4);
    ZASSERT(rr[1] == -4);
    ZASSERT(rr[2] == INT32_MAX); /* 0x40000000 << 1 saturates */
    ZASSERT(rr[3] == 56);

    /* sqshlu: signed input, unsigned saturating result, .8b. */
    int8x8_t sa = {-1, 0, 100, -128, 3, 4, 5, 6};
    uint8x8_t sur;
    asm volatile("sqshlu %0.8b, %1.8b, #1" : "=w"(sur) : "w"(sa));
    ZASSERT(sur[0] == 0);   /* -2 saturates to zero */
    ZASSERT(sur[1] == 0);
    ZASSERT(sur[2] == 200);
    ZASSERT(sur[3] == 0);   /* -256 saturates */
    ZASSERT(sur[4] == 6);

    /* sqrshl: rounding saturating left shift by register, .2s. */
    int32x2_t qa = {5, -5};
    int32x2_t qsh = {1, 1};
    int32x2_t qr;
    asm volatile("sqrshl %0.2s, %1.2s, %2.2s" : "=w"(qr) : "w"(qa), "w"(qsh));
    ZASSERT(qr[0] == 10 && qr[1] == -10);

    /* sqshrn: signed saturating narrowing right shift, .4h <- .4s. */
    int32x4_t na = {0x00012345, INT32_MAX, INT32_MIN, 0x7FFFFFF0};
    int16x4_t nr;
    asm volatile("sqshrn %0.4h, %1.4s, #4" : "=w"(nr) : "w"(na));
    ZASSERT(nr[0] == 0x1234);
    ZASSERT(nr[1] == INT16_MAX); /* 0x07FFFFFF overflows 16 bits */
    ZASSERT(nr[2] == INT16_MIN);
    ZASSERT(nr[3] == 0x7FFF);

    /* sqrshrn: rounding signed saturating narrowing, .4h <- .4s. */
    int32x4_t na2 = {0x00008000, 0x00008008, -0x8000, 0x12345678};
    int16x4_t nr2;
    asm volatile("sqrshrn %0.4h, %1.4s, #4" : "=w"(nr2) : "w"(na2));
    /* Rounding: (x + 8) >> 4. */
    ZASSERT(nr2[0] == sat16((0x00008000 + 8) >> 4));
    ZASSERT(nr2[1] == sat16((0x00008008 + 8) >> 4));
    ZASSERT(nr2[2] == sat16((-0x8000 + 8) >> 4));
    ZASSERT(nr2[3] == sat16((0x12345678 + 8) >> 4));

    /* sqrshrn2: results go to the upper half; lower half preserved. */
    int32x4_t na3 = {0x0000FFFF, 0x00018000, 1, -1};
    int16x8_t nr3 = {0x1234, 0x5678, 0x9ABC, 0xDEF0, 0, 0, 0, 0};
    asm volatile("sqrshrn2 %0.8h, %1.4s, #8" : "+w"(nr3) : "w"(na3));
    ZASSERT(nr3[0] == 0x1234 && nr3[1] == 0x5678); /* preserved */
    ZASSERT(nr3[2] == (int16_t)0x9ABC && nr3[3] == (int16_t)0xDEF0);
    ZASSERT(nr3[4] == sat16((0x0000FFFF + 0x80) >> 8)); /* 0x100 */
    ZASSERT(nr3[5] == sat16((0x00018000 + 0x80) >> 8)); /* 0x180 */
    ZASSERT(nr3[6] == 0);
    ZASSERT(nr3[7] == 0);

    /* uqshrn: unsigned saturating narrowing, .8b <- .8h. */
    int16x8_t ua2 = {0x0100, 0x00FF, 0x1234, 0, 1, 0x200, 0x7F, 0x80};
    uint8x8_t unr;
    asm volatile("uqshrn %0.8b, %1.8h, #1" : "=w"(unr) : "w"(ua2));
    ZASSERT(unr[0] == 0x80);
    ZASSERT(unr[1] == 0x7F);
    /* 0x1234 >> 1 = 0x091A, which overflows 8 bits unsigned -> 0xFF. */
    ZASSERT(unr[2] == 0xFF);
    ZASSERT(unr[3] == 0);
    ZASSERT(unr[4] == 0);
    ZASSERT(unr[5] == 0xFF);
    ZASSERT(unr[6] == 0x3F);
    ZASSERT(unr[7] == 0x40);

    /* uqrshrn: rounding unsigned saturating narrowing, .4h <- .4s. */
    uint32x4_t ua3 = {0x00010000, 0x0000FFFF, 0xFFFFFFFFU, 0x12345678};
    uint16x4_t unr2;
    asm volatile("uqrshrn %0.4h, %1.4s, #8" : "=w"(unr2) : "w"(ua3));
    ZASSERT(unr2[0] == usat16(((uint64_t)0x00010000 + 0x80) >> 8));
    ZASSERT(unr2[1] == usat16(((uint64_t)0x0000FFFF + 0x80) >> 8));
    ZASSERT(unr2[2] == usat16(((uint64_t)0xFFFFFFFFU + 0x80) >> 8));
    ZASSERT(unr2[3] == usat16(((uint64_t)0x12345678 + 0x80) >> 8));

    /* sqshrun: signed input, unsigned saturating narrowing, .8b <- .8h. */
    int16x8_t da = {-1, -256, 0x00FF, 0x0100, 0x7FFF, -0x8000, 0x1234, 0x123};
    uint8x8_t dr;
    asm volatile("sqshrun %0.8b, %1.8h, #4" : "=w"(dr) : "w"(da));
    ZASSERT(dr[0] == 0);  /* -1 >> 4 = -1 -> saturates to 0 */
    ZASSERT(dr[1] == 0);  /* -16 -> 0 */
    ZASSERT(dr[2] == 0x0F);
    ZASSERT(dr[3] == 0x10);
    ZASSERT(dr[4] == 0xFF); /* 0x7FFF >> 4 = 0x7FF -> saturates */
    ZASSERT(dr[5] == 0);
    ZASSERT(dr[6] == 0xFF); /* 0x1234 >> 4 = 0x123 -> saturates */
    ZASSERT(dr[7] == 0x12);

    /* sqrshrun: rounding unsigned saturating narrowing, .8b <- .8h. */
    int16x8_t da2 = {-1, 0x001F, 0x0020, 0x1234, -0x100, 0x0F, 0x10, 0x11};
    uint8x8_t dr2;
    asm volatile("sqrshrun %0.8b, %1.8h, #1" : "=w"(dr2) : "w"(da2));
    ZASSERT(dr2[0] == 0);  /* (-1 + 1) >> 1 = 0 */
    ZASSERT(dr2[1] == 0x10); /* (0x1F + 1) >> 1 */
    ZASSERT(dr2[2] == 0x10); /* (0x20 + 1) >> 1 */
    ZASSERT(dr2[3] == usat8((0x1234 + 1) >> 1));
    ZASSERT(dr2[4] == 0);
    ZASSERT(dr2[5] == 0x08); /* (0xF + 1) >> 1 */
    ZASSERT(dr2[6] == 0x08);
    ZASSERT(dr2[7] == 0x09); /* (0x11 + 1) >> 1 */

    /* shrn: non-saturating narrowing right shift, .4h <- .4s. */
    int32x4_t za = {0x12345678, 0x0000ABCD, -1, 0x01020304};
    int16x4_t zr;
    asm volatile("shrn %0.4h, %1.4s, #4" : "=w"(zr) : "w"(za));
    ZASSERT(zr[0] == 0x4567);
    ZASSERT(zr[1] == 0x0ABC);
    ZASSERT(zr[2] == (int16_t)0xFFFF); /* arithmetic shift, truncation */
    ZASSERT(zr[3] == 0x2030); /* 0x01020304 >> 4 = 0x00102030 */

    /* rshrn: rounding narrowing, .4h <- .4s. */
    int32x4_t wa = {0x00007F80, 0x00000100, 0x0000FFFF, 0x00018000};
    int16x4_t wr;
    asm volatile("rshrn %0.4h, %1.4s, #8" : "=w"(wr) : "w"(wa));
    ZASSERT(wr[0] == 0x80);
    ZASSERT(wr[1] == 0x01);
    /* (0xFFFF + 0x80) >> 8 = 0x100; no saturation (rshrn truncates). */
    ZASSERT(wr[2] == 0x100);
    ZASSERT(wr[3] == 0x180); /* (0x18000 + 0x80) >> 8 = 0x180 */

    /* sqxtn: signed saturating narrowing, .4h <- .4s. */
    int32x4_t ea = {0x7FFFFFFF, 0x80000000, 0x00054321, -1};
    int16x4_t er;
    asm volatile("sqxtn %0.4h, %1.4s" : "=w"(er) : "w"(ea));
    ZASSERT(er[0] == INT16_MAX);
    ZASSERT(er[1] == INT16_MIN);
    ZASSERT(er[2] == INT16_MAX); /* 0x54321 overflows 16 bits */
    ZASSERT(er[3] == -1);

    /* sqxtn2: the results (from all four source lanes) go to the upper
       half of the destination; the lower half must be preserved, so this
       is tested with a tied output. */
    int32x4_t ea2 = {0x00001111, 0x00002222, 0x7FFFFFFF, 0x00002345};
    int16x8_t er2 = {0x55AA, 0xA55A, 0x1234, 0x4321, 0, 0, 0, 0};
    asm volatile("sqxtn2 %0.8h, %1.4s" : "+w"(er2) : "w"(ea2));
    ZASSERT(er2[0] == 0x55AA && er2[1] == (int16_t)0xA55A); /* preserved */
    ZASSERT(er2[2] == 0x1234 && er2[3] == 0x4321);
    ZASSERT(er2[4] == 0x1111); /* lane 0 of source, narrowed */
    ZASSERT(er2[5] == 0x2222);
    ZASSERT(er2[6] == INT16_MAX); /* lane 2 of source saturates */
    ZASSERT(er2[7] == 0x2345);

    /* uqxtn: unsigned saturating narrowing, .8b <- .8h. */
    uint16x8_t fa = {0x00FF, 0x0100, 0x8000, 0xFFFF, 0x0001, 0x0080, 0x1234, 0};
    uint8x8_t fr;
    asm volatile("uqxtn %0.8b, %1.8h" : "=w"(fr) : "w"(fa));
    ZASSERT(fr[0] == 0xFF);
    ZASSERT(fr[1] == 0xFF); /* saturates */
    ZASSERT(fr[2] == 0xFF);
    ZASSERT(fr[3] == 0xFF);
    ZASSERT(fr[4] == 0x01);
    ZASSERT(fr[5] == 0x80);
    ZASSERT(fr[6] == 0xFF);
    ZASSERT(fr[7] == 0);

    /* uqxtn2: results go to the upper half; lower half preserved. */
    uint16x8_t fa2 = {0x00FF, 0x0100, 0x0000, 0xFFFF, 0x0001, 0x0080, 0x1234, 0x00FF};
    uint8x16_t fr2 = {0x77, 1, 2, 0x99, 4, 5, 6, 0x33,
                      0, 0, 0, 0, 0, 0, 0, 0};
    asm volatile("uqxtn2 %0.16b, %1.8h" : "+w"(fr2) : "w"(fa2));
    ZASSERT(fr2[0] == 0x77 && fr2[3] == 0x99 && fr2[7] == 0x33); /* preserved */
    ZASSERT(fr2[8] == 0xFF);
    ZASSERT(fr2[9] == 0xFF);
    ZASSERT(fr2[10] == 0);
    ZASSERT(fr2[11] == 0xFF);
    ZASSERT(fr2[12] == 0x01);
    ZASSERT(fr2[13] == 0x80);
    ZASSERT(fr2[14] == 0xFF);
    ZASSERT(fr2[15] == 0xFF);
    return 0;
}
