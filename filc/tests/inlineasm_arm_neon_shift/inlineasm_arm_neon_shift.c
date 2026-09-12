#include <stdfil.h>
#include <arm_neon.h>

int main(void)
{
    int32x4_t a = {1, 2, 3, 4};
    int32x4_t r;

    /* shl: left shift by immediate. */
    asm volatile("shl %0.4s, %1.4s, #3" : "=w"(r) : "w"(a));
    ZASSERT(r[0] == 8 && r[1] == 16 && r[3] == 32);

    /* sshr: arithmetic right shift. */
    int32x4_t neg = {-8, -16, -32, -64};
    asm volatile("sshr %0.4s, %1.4s, #2" : "=w"(r) : "w"(neg));
    ZASSERT(r[0] == -2 && r[1] == -4 && r[3] == -16);

    /* ushr: logical right shift on unsigned data. */
    uint32x4_t u = {0x80000000U, 0x40000000U, 16U, 256U};
    uint32x4_t ur;
    asm volatile("ushr %0.4s, %1.4s, #4" : "=w"(ur) : "w"(u));
    ZASSERT(ur[0] == 0x08000000U && ur[2] == 1U && ur[3] == 16U);

    /* ssra: shift right and accumulate (tied). */
    int32x4_t acc = {100, 100, 100, 100};
    asm volatile("ssra %0.4s, %1.4s, #2" : "+w"(acc) : "w"(a));
    ZASSERT(acc[0] == 100 && acc[1] == 100 && acc[2] == 100 && acc[3] == 101);

    int32x4_t acc2 = {0, 0, 0, 0};
    int32x4_t val = {40, 40, 40, 40};
    asm volatile("ssra %0.4s, %1.4s, #2" : "+w"(acc2) : "w"(val));
    ZASSERT(acc2[0] == 10 && acc2[3] == 10);

    /* usra on unsigned data. */
    uint32x4_t uacc = {0, 0, 0, 0};
    uint32x4_t uval = {64, 64, 64, 64};
    asm volatile("usra %0.4s, %1.4s, #3" : "+w"(uacc) : "w"(uval));
    ZASSERT(uacc[0] == 8 && uacc[3] == 8);

    /* srshr/urshr: rounding shifts. */
    int32x4_t rr;
    asm volatile("srshr %0.4s, %1.4s, #1" : "=w"(rr) : "w"(val));
    ZASSERT(rr[0] == 20 && rr[3] == 20);

    uint32x4_t urr;
    uint32x4_t uval2 = {5, 7, 9, 11};
    asm volatile("urshr %0.4s, %1.4s, #1" : "=w"(urr) : "w"(uval2));
    ZASSERT(urr[0] == 3 && urr[1] == 4 && urr[2] == 5 && urr[3] == 6);

    /* sri: shift right and insert (tied destination). */
    uint32x4_t ins = {0xFFFFFFFFU, 0xFFFFFFFFU, 0xFFFFFFFFU, 0xFFFFFFFFU};
    uint32x4_t src = {0xFFU, 0xFFU, 0xFFU, 0xFFU};
    asm volatile("sri %0.4s, %1.4s, #4" : "+w"(ins) : "w"(src));
    ZASSERT(ins[0] == 0xF000000FU && ins[3] == 0xF000000FU);

    /* sli: shift left and insert (tied destination). */
    uint32x4_t ins2 = {0xFFU, 0xFFU, 0xFFU, 0xFFU};
    asm volatile("sli %0.4s, %1.4s, #4" : "+w"(ins2) : "w"(src));
    ZASSERT(ins2[0] == 0xFFFU && ins2[3] == 0xFFFU);

    /* 16-bit lanes. */
    int16x8_t ha = {1, 2, 3, 4, 5, 6, 7, 8};
    int16x8_t hr;
    asm volatile("shl %0.8h, %1.8h, #2" : "=w"(hr) : "w"(ha));
    ZASSERT(hr[0] == 4 && hr[7] == 32);

    asm volatile("sshr %0.8h, %1.8h, #1" : "=w"(hr) : "w"(ha));
    ZASSERT(hr[0] == 0 && hr[1] == 1 && hr[7] == 4);
    return 0;
}
