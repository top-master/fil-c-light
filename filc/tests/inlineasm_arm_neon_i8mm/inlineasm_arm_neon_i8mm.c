#include <stdfil.h>
#include <stdint.h>

/* FEAT_I8MM integer matrix multiply-accumulate. All four instructions are
   three-operand RMW-accumulate (tied "+w" destination). The C references
   below are exact transliterations of the architecture pseudocode:

   MatMulAdd (smmla/ummla/usmmla): for i,j in 0..1:
       result[2i+j] = addend[2i+j] + sum(k=0..7) op1[8i+k] * op2[8j+k]
   with signedness (op1, op2) = (signed, signed) for smmla,
   (unsigned, unsigned) for ummla, (unsigned, signed) for usmmla.

   USDOT (vector): result[e] = addend[e] + sum(b=0..3) u8(a[4e+b]) * s8(b[4e+b]).
   USDOT (by element Vm.4b[i]): the b bytes come from vm[4i+b] instead. */

typedef float v4 __attribute__((vector_size(16)));
typedef uint32_t u4 __attribute__((vector_size(16)));
typedef uint8_t u16b __attribute__((vector_size(16)));

static int8_t sbyte(uint32_t w, int i)
{
    return (int8_t)(uint8_t)(w >> (8 * i));
}
static uint8_t ubyte(uint32_t w, int i)
{
    return (uint8_t)(w >> (8 * i));
}

/* MatMulAdd over the four 32-bit lanes a[0..3] of each register. */
static void matmuladd_ref(uint32_t d[4], const uint32_t o1[4],
                          const uint32_t o2[4], int op1_unsigned,
                          int op2_unsigned)
{
    for (int i = 0; i < 2; ++i) {
        for (int j = 0; j < 2; ++j) {
            int32_t sum = (int32_t)d[2 * i + j];
            for (int k = 0; k < 8; ++k) {
                /* op1 byte (8*i+k): word (8*i+k)/4, byte (8*i+k)%4 */
                uint32_t w1 = o1[(8 * i + k) / 4];
                uint32_t w2 = o2[(8 * j + k) / 4];
                int32_t v1 = op1_unsigned ? (int32_t)ubyte(w1, (8 * i + k) % 4)
                                          : (int32_t)sbyte(w1, (8 * i + k) % 4);
                int32_t v2 = op2_unsigned ? (int32_t)ubyte(w2, (8 * j + k) % 4)
                                          : (int32_t)sbyte(w2, (8 * j + k) % 4);
                sum += v1 * v2;
            }
            d[2 * i + j] = (uint32_t)sum;
        }
    }
}

int main(void)
{
    /* Two 16-byte operand vectors with a mix of positive/negative bytes. */
    u16b a = {3, 200, 7, 128, 1, 2, 3, 4, 250, 250, 250, 250, 9, 9, 9, 9};
    u16b b = {4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 200, 100, 50, 25};
    u4 acc = {100, 200, 300, 400};
    asm volatile("smmla %0.4s, %1.16b, %2.16b" : "+w"(acc) : "w"(a), "w"(b));
    {
        uint32_t dref[4] = {100, 200, 300, 400};
        uint32_t o1[4], o2[4];
        __builtin_memcpy(o1, &a, 16);
        __builtin_memcpy(o2, &b, 16);
        matmuladd_ref(dref, o1, o2, 0, 0);
        for (int i = 0; i < 4; ++i)
            ZASSERT(acc[i] == dref[i]);
    }

    /* ummla: unsigned x unsigned. */
    acc = (u4){100, 200, 300, 400};
    asm volatile("ummla %0.4s, %1.16b, %2.16b" : "+w"(acc) : "w"(a), "w"(b));
    {
        uint32_t dref[4] = {100, 200, 300, 400};
        uint32_t o1[4], o2[4];
        __builtin_memcpy(o1, &a, 16);
        __builtin_memcpy(o2, &b, 16);
        matmuladd_ref(dref, o1, o2, 1, 1);
        for (int i = 0; i < 4; ++i)
            ZASSERT(acc[i] == dref[i]);
    }

    /* usmmla: unsigned x signed. */
    acc = (u4){100, 200, 300, 400};
    asm volatile("usmmla %0.4s, %1.16b, %2.16b" : "+w"(acc) : "w"(a), "w"(b));
    {
        uint32_t dref[4] = {100, 200, 300, 400};
        uint32_t o1[4], o2[4];
        __builtin_memcpy(o1, &a, 16);
        __builtin_memcpy(o2, &b, 16);
        matmuladd_ref(dref, o1, o2, 1, 0);
        for (int i = 0; i < 4; ++i)
            ZASSERT(acc[i] == dref[i]);
    }

    /* usdot (vector): result[e] += sum(b=0..3) u8(a[4e+b]) * s8(b[4e+b]). */
    acc = (u4){1000, 2000, 3000, 4000};
    asm volatile("usdot %0.4s, %1.16b, %2.16b" : "+w"(acc) : "w"(a), "w"(b));
    {
        uint32_t o1[4], o2[4];
        __builtin_memcpy(o1, &a, 16);
        __builtin_memcpy(o2, &b, 16);
        for (int e = 0; e < 4; ++e) {
            int32_t real = (int32_t)(1000u + 1000u * (uint32_t)e);
            for (int k = 0; k < 4; ++k) {
                uint32_t w1 = o1[e];
                uint32_t w2 = o2[e];
                real += (int32_t)ubyte(w1, k) * (int32_t)sbyte(w2, k);
            }
            ZASSERT(acc[e] == (uint32_t)real);
        }
    }

    /* usdot (by element): Vm.4b[index]. */
    acc = (u4){0, 0, 0, 0};
    asm volatile("usdot %0.4s, %1.16b, %2.4b[1]" : "+w"(acc) : "w"(a), "w"(b));
    {
        uint32_t o1[4], o2[4];
        __builtin_memcpy(o1, &a, 16);
        __builtin_memcpy(o2, &b, 16);
        for (int e = 0; e < 4; ++e) {
            int32_t real = 0;
            for (int k = 0; k < 4; ++k) {
                uint32_t w1 = o1[e];
                uint32_t w2 = o2[1]; /* element pair index 1 */
                real += (int32_t)ubyte(w1, k) * (int32_t)sbyte(w2, k);
            }
            ZASSERT(acc[e] == (uint32_t)real);
        }
    }

    /* Spot checks with hand-computed values. */
    u16b sa = {1, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0};
    u16b sb = {10, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0};
    acc = (u4){0, 0, 0, 0};
    /* Lane j of each pair i dots a's byte-row 8i with b's byte-row 8j.
       Lane 0 (i=0,j=0): 1*10 = 10. Lane 1 (i=0,j=1): 1*3 = 3.
       Lane 2 (i=1,j=0): (-1)*10 = -10. Lane 3 (i=1,j=1): (-1)*3 = -3. */
    asm volatile("smmla %0.4s, %1.16b, %2.16b" : "+w"(acc) : "w"(sa), "w"(sb));
    ZASSERT(acc[0] == 10);
    ZASSERT(acc[1] == 3);
    ZASSERT(acc[2] == (uint32_t)-10);
    ZASSERT(acc[3] == (uint32_t)-3);
    /* ummla: same but unsigned: lane 2 gets 255*10 = 2550, lane 3 255*3. */
    acc = (u4){0, 0, 0, 0};
    asm volatile("ummla %0.4s, %1.16b, %2.16b" : "+w"(acc) : "w"(sa), "w"(sb));
    ZASSERT(acc[0] == 10);
    ZASSERT(acc[1] == 3);
    ZASSERT(acc[2] == 2550);
    ZASSERT(acc[3] == 765);
    /* usdot: lane e dots a's bytes 4e..4e+3 with b's bytes 4e..4e+3.
       Lane 0: 1*10 = 10. Lane 2 (a bytes 8..11 = {255,0,0,0} vs b bytes
       8..11 = {3,0,0,0}): 255*3 = 765. */
    acc = (u4){0, 0, 0, 0};
    asm volatile("usdot %0.4s, %1.16b, %2.16b" : "+w"(acc) : "w"(sa), "w"(sb));
    ZASSERT(acc[0] == 10);
    ZASSERT(acc[2] == 765);
    return 0;
}
