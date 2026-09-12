#include <stdfil.h>
#include <arm_neon.h>

/* Kitchen-sink runtime coverage for the last batch of A64 inline-asm
   validator entries: GPR variable shifts (lslv), integer NEON compares
   (cmeq/cmge/cmgt/cmhi/cmhs/cmle/cmlt, vector and zero forms), FP select
   and multiply-negate (fcsel/fnmul), across-vector reductions
   (fmaxv/fminv), vector immediates (movi/mvni with lsl/msl modifiers),
   bfc, widening multiply-accumulate (smaddl/smsubl/umaddl/umsubl/smnegl/
   umnegl), absolute-difference/pairwise/across-lane families (saba/sabal/
   uabal/sadalp/saddlp/uaddlp/saddlv/uaddlv), shifts by register
   (sshl/ushl/srshl/urshl/uqrshl), narrowing accumulate (srsra/ursra),
   widening shifts (shll/sshll/ushll/sxtl/uxtl), narrowing (sqxtun/xtn),
   and the register-list table lookups (tbl/tbx). Everything here
   assembles under the default -march. */

int main(void)
{
    unsigned long x = 1, s = 5;
    asm volatile("lslv %0, %0, %1" : "+r"(x) : "r"(s));
    ZASSERT(x == 32);

    int32x4_t a = {1, -1, 3, -4};
    int32x4_t b = {2, -1, 0, -5};
    uint32x4_t r;
    asm volatile("cmgt %0.4s, %1.4s, %2.4s" : "=w"(r) : "w"(a), "w"(b));
    ZASSERT(r[0]==0 && r[1]==0 && r[2]==0xFFFFFFFFu && r[3]==0xFFFFFFFFu);
    asm volatile("cmgt %0.4s, %1.4s, #0" : "=w"(r) : "w"(a));
    ZASSERT(r[0]==0xFFFFFFFFu && r[1]==0 && r[2]==0xFFFFFFFFu && r[3]==0);
    asm volatile("cmeq %0.4s, %1.4s, #0" : "=w"(r) : "w"(a));
    ZASSERT(r[0]==0 && r[1]==0 && r[2]==0 && r[3]==0);
    asm volatile("cmge %0.4s, %1.4s, %2.4s" : "=w"(r) : "w"(a), "w"(b));
    ZASSERT(r[0]==0 && r[1]==0xFFFFFFFFu && r[2]==0xFFFFFFFFu && r[3]==0xFFFFFFFFu);
    asm volatile("cmhi %0.4s, %1.4s, %2.4s" : "=w"(r) : "w"(a), "w"(b));
    ZASSERT(r[0]==0 && r[1]==0 && r[2]==0xFFFFFFFFu && r[3]==0xFFFFFFFFu);
    asm volatile("cmhs %0.4s, %1.4s, %2.4s" : "=w"(r) : "w"(a), "w"(b));
    ZASSERT(r[0]==0 && r[1]==0xFFFFFFFFu && r[2]==0xFFFFFFFFu && r[3]==0xFFFFFFFFu);
    asm volatile("cmle %0.4s, %1.4s, #0" : "=w"(r) : "w"(a));
    ZASSERT(r[0]==0 && r[1]==0xFFFFFFFFu && r[2]==0 && r[3]==0xFFFFFFFFu);
    asm volatile("cmlt %0.4s, %1.4s, #0" : "=w"(r) : "w"(a));
    ZASSERT(r[0]==0 && r[1]==0xFFFFFFFFu && r[2]==0 && r[3]==0xFFFFFFFFu);
    { int64x1_t sa = {5}, sb = {3}; uint64x1_t sr;
      asm volatile("cmgt %d0, %d1, %d2" : "=w"(sr) : "w"(sa), "w"(sb));
      ZASSERT(sr[0] == 0xFFFFFFFFFFFFFFFFUL); }

    float f1 = 1.5f, f2 = 2.5f, fres;
    long c1 = 5, c2 = 3;
    asm volatile("cmp %1, %2\n\tfcsel %s0, %s3, %s4, gt"
                 : "=w"(fres) : "r"(c1), "r"(c2), "w"(f1), "w"(f2) : "cc");
    ZASSERT(fres == 1.5f);
    float fnres;
    asm volatile("fnmul %s0, %s1, %s2" : "=w"(fnres) : "w"(f1), "w"(f2));
    ZASSERT(fnres == -(1.5f * 2.5f));

    float32x4_t fv = {3.0f, 1.0f, 7.5f, 2.0f};
    float fmax, fmin;
    asm volatile("fmaxv %s0, %1.4s" : "=w"(fmax) : "w"(fv));
    asm volatile("fminv %s0, %1.4s" : "=w"(fmin) : "w"(fv));
    ZASSERT(fmax == 7.5f && fmin == 1.0f);

    uint16x4_t mi;
    asm volatile("movi %0.4h, #255" : "=w"(mi));
    ZASSERT(mi[0] == 0x00FF);
    asm volatile("movi %0.4h, #255, lsl #8" : "=w"(mi));
    ZASSERT(mi[0] == 0xFF00);
    uint32x4_t ms;
    asm volatile("movi %0.4s, #0xc0, msl #8" : "=w"(ms));
    asm volatile("mvni %0.4h, #0xf0, lsl #8" : "=w"(mi));
    ZASSERT(mi[0] == 0x0FFF);

    unsigned long bf = 0xFFFFFFFFFFFFFFFFUL;
    asm volatile("bfc %0, #4, #8" : "+r"(bf));
    ZASSERT(bf == 0xFFFFFFFFFFFFF00FUL);

    { long out, accum = 100; int wn = 3, wm = 4;
      asm volatile("smaddl %0, %w1, %w2, %3" : "=r"(out) : "r"(wn), "r"(wm), "r"(accum));
      ZASSERT(out == 112);
      asm volatile("smsubl %0, %w1, %w2, %3" : "=r"(out) : "r"(wn), "r"(wm), "r"(accum));
      ZASSERT(out == 88);
      asm volatile("smnegl %0, %w1, %w2" : "=r"(out) : "r"(wn), "r"(wm));
      ZASSERT(out == -12);
      unsigned un = 0xFFFFFFFFu, um = 2; unsigned long uacc = 10, uout;
      asm volatile("umaddl %0, %w1, %w2, %3" : "=r"(uout) : "r"(un), "r"(um), "r"(uacc));
      ZASSERT(uout == 10UL + 2UL*4294967295UL);
      asm volatile("umsubl %0, %w1, %w2, %3" : "=r"(uout) : "r"(un), "r"(um), "r"(uacc));
      ZASSERT(uout == (long)(10UL - 2UL*4294967295UL));
      asm volatile("umnegl %0, %w1, %w2" : "=r"(uout) : "r"(un), "r"(um));
      ZASSERT(uout == (long)(-2UL*4294967295UL)); }

    { uint8x16_t acc = vdupq_n_u8(1), p = vdupq_n_u8(10), q = vdupq_n_u8(3);
      asm volatile("saba %0.16b, %1.16b, %2.16b" : "+w"(acc) : "w"(p), "w"(q));
      ZASSERT(acc[0] == 8 && acc[15] == 8); }
    { uint16x8_t acc = vdupq_n_u16(1); uint8x8_t p = vdup_n_u8(10), q = vdup_n_u8(3);
      asm volatile("sabal %0.8h, %1.8b, %2.8b" : "+w"(acc) : "w"(p), "w"(q));
      ZASSERT(acc[0] == 8 && acc[7] == 8); }
    { uint16x8_t acc = vdupq_n_u16(1); uint8x8_t p = vdup_n_u8(10), q = vdup_n_u8(3);
      asm volatile("uabal %0.8h, %1.8b, %2.8b" : "+w"(acc) : "w"(p), "w"(q));
      ZASSERT(acc[0] == 8); }
    { int16x8_t src = {1,2,3,4,5,6,7,8}; int32x4_t acc = vdupq_n_s32(0), out;
      asm volatile("sadalp %0.4s, %1.8h" : "+w"(acc) : "w"(src));
      ZASSERT(acc[0]==3 && acc[3]==15);
      asm volatile("saddlp %0.4s, %1.8h" : "=w"(out) : "w"(src));
      ZASSERT(out[0]==3 && out[3]==15); }
    { uint8x8_t src = {1,2,3,4,5,6,7,8}; uint16x8_t sum;
      asm volatile("uaddlv %h0, %1.8b" : "=w"(sum) : "w"(src));
      ZASSERT(sum[0] == 36); }
    { uint8x8_t src = {200,100,50,25,1,2,3,4}; uint16x8_t sum;
      asm volatile("saddlv %h0, %1.8b" : "=w"(sum) : "w"(src));
        ZASSERT(sum[0] == 129); }
    { int32x4_t sv = {4, 8, 16, 32}, sh = {1, 1, 2, 2}, out;
      asm volatile("sshl %0.4s, %1.4s, %2.4s" : "=w"(out) : "w"(sv), "w"(sh));
      ZASSERT(out[0]==8 && out[3]==128);
      asm volatile("ushl %0.4s, %1.4s, %2.4s" : "=w"(out) : "w"(sv), "w"(sh));
      ZASSERT(out[0]==8 && out[3]==128);
      asm volatile("srshl %0.4s, %1.4s, %2.4s" : "=w"(out) : "w"(sv), "w"(sh));
      ZASSERT(out[0]==8 && out[3]==128);
      asm volatile("urshl %0.4s, %1.4s, %2.4s" : "=w"(out) : "w"(sv), "w"(sh));
      ZASSERT(out[0]==8 && out[3]==128);
      uint32x4_t uv = {0xFFFFFFFFu, 5, 6, 7}, uo;
      asm volatile("uqrshl %0.4s, %1.4s, %2.4s" : "=w"(uo) : "w"(uv), "w"(sh));
      ZASSERT(uo[0] == 0xFFFFFFFFu); }
    { int16x4_t acc = {0,0,0,0}, src = {100,200,300,400};
      asm volatile("srsra %0.4h, %1.4h, #4" : "+w"(acc) : "w"(src));
      ZASSERT(acc[0]==6 && acc[1]==13 && acc[2]==19 && acc[3]==25);
      uint16x4_t uacc = {0,0,0,0}, usrc = {100,200,300,400};
      asm volatile("ursra %0.4h, %1.4h, #4" : "+w"(uacc) : "w"(usrc));
      ZASSERT(uacc[0]==6 && uacc[3]==25); }
    { int8x8_t src = {(signed char)0x80, 1, 2, 3, 4, 5, 6, 7}; int16x8_t out;
      asm volatile("sshll %0.8h, %1.8b, #0" : "=w"(out) : "w"(src));
      ZASSERT(out[0] == -128 && out[1] == 1);
      asm volatile("sxtl %0.8h, %1.8b" : "=w"(out) : "w"(src));
      ZASSERT(out[0] == -128);
      asm volatile("ushll %0.8h, %1.8b, #0" : "=w"(out) : "w"(src));
      ZASSERT(out[0] == 128);
      asm volatile("uxtl %0.8h, %1.8b" : "=w"(out) : "w"(src));
      ZASSERT(out[0] == 128);
      uint8x8_t usrc = {0x80, 1, 2, 3, 4, 5, 6, 7}; uint16x8_t uout;
      asm volatile("shll %0.8h, %1.8b, #8" : "=w"(uout) : "w"(usrc));
      ZASSERT(uout[0] == 0x8000); }
    { int16x8_t src = {-5, 300, 100, 1000, 0, 1, 2, 3}; uint8x8_t out;
      asm volatile("sqxtun %0.8b, %1.8h" : "=w"(out) : "w"(src));
      ZASSERT(out[0] == 0 && out[1] == 255 && out[2] == 100 && out[3] == 255); }
    { uint16x8_t src = {0x1234, 0x5678, 0x9abc, 0xdef0, 0, 0, 0, 0}; uint8x8_t out;
      asm volatile("xtn %0.8b, %1.8h" : "=w"(out) : "w"(src));
      ZASSERT(out[0] == 0x34 && out[1] == 0x78 && out[2] == 0xbc && out[3] == 0xf0); }
    { uint8x16_t table; for (int i = 0; i < 16; i++) table[i] = 0x40 + i;
      uint8x16_t idx = {0, 1, 15, 16, 17, 200, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
      uint8x16_t out;
      asm volatile("tbl %0.16b, { %1.16b }, %2.16b" : "=w"(out) : "w"(table), "w"(idx));
      ZASSERT(out[0] == 0x40 && out[1] == 0x41 && out[2] == 0x4f);
      ZASSERT(out[3] == 0 && out[4] == 0 && out[5] == 0 && out[6] == 0x43); }
    { register uint8x16_t t1 asm("v16"); register uint8x16_t t2 asm("v17"); for (int i = 0; i < 16; i++) { t1[i] = 0x40 + i; t2[i] = 0x50 + i; }
      uint8x16_t idx = {0, 15, 16, 17, 31, 32, 3, 20, 0, 0, 0, 0, 0, 0, 0, 0};
      uint8x16_t out;
      asm volatile("tbl %0.16b, { %1.16b, %2.16b }, %3.16b" : "=w"(out) : "w"(t1), "w"(t2), "w"(idx));
      ZASSERT(out[0] == 0x40 && out[1] == 0x4f && out[2] == 0x50 && out[3] == 0x51);
      ZASSERT(out[4] == 0x5f && out[5] == 0 && out[7] == 0x54); }
    { register uint8x16_t t1 asm("v16"); register uint8x16_t t2 asm("v17"); register uint8x16_t t3 asm("v18"); register uint8x16_t t4 asm("v19");
      for (int i = 0; i < 16; i++) { t1[i]=0x40+i; t2[i]=0x50+i; t3[i]=0x60+i; t4[i]=0x70+i; }
      uint8x16_t idx = {0, 16, 32, 48, 63, 64, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0};
      uint8x16_t out;
      asm volatile("tbl %0.16b, { %1.16b, %2.16b, %3.16b, %4.16b }, %5.16b"
                   : "=w"(out) : "w"(t1), "w"(t2), "w"(t3), "w"(t4), "w"(idx));
      ZASSERT(out[0] == 0x40 && out[1] == 0x50 && out[2] == 0x60 && out[3] == 0x70);
      ZASSERT(out[4] == 0x7f && out[5] == 0 && out[6] == 0x42); }
    { uint8x16_t table; for (int i = 0; i < 16; i++) table[i] = 0x40 + i;
      uint8x16_t idx = {0, 1, 16, 17, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
      uint8x16_t out; for (int i = 0; i < 16; i++) out[i] = 0xEE;
      asm volatile("tbx %0.16b, { %1.16b }, %2.16b" : "+w"(out) : "w"(table), "w"(idx));
      ZASSERT(out[0] == 0x40 && out[1] == 0x41 && out[2] == 0xEE && out[3] == 0xEE); }
    return 0;
}
