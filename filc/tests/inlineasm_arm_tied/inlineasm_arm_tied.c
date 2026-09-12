#include <stdfil.h>
#include <arm_neon.h>

int main(void)
{
    /* "+r" read-modify-write patterns. */
    unsigned long x = 100;
    asm volatile("add %0, %0, %1" : "+r"(x) : "r"(23UL));
    ZASSERT(x == 123);

    x = 100;
    asm volatile("sub %0, %0, %1" : "+r"(x) : "r"(58UL));
    ZASSERT(x == 42);

    x = 0xF0;
    asm volatile("orr %0, %0, %1" : "+r"(x) : "r"(0x0FUL));
    ZASSERT(x == 0xFF);

    x = 0xFF;
    asm volatile("and %0, %0, %1" : "+r"(x) : "r"(0x3CUL));
    ZASSERT(x == 0x3C);

    x = 0xFF;
    asm volatile("eor %0, %0, %1" : "+r"(x) : "r"(0x0FUL));
    ZASSERT(x == 0xF0);

    x = 1;
    asm volatile("lsl %0, %0, %1" : "+r"(x) : "r"(5UL));
    ZASSERT(x == 32);

    x = 0x12345678;
    asm volatile("extr %0, %0, %1, #8" : "+r"(x) : "r"(0xABCDEF00UL));
    ZASSERT(x == ((0x78UL << 56) | (0xABCDEF00UL >> 8)));

    /* Vector tied accumulate: mla. */
    int32x4_t acc = {1, 2, 3, 4};
    int32x4_t p = {2, 2, 2, 2};
    int32x4_t q = {5, 6, 7, 8};
    asm volatile("mla %0.4s, %1.4s, %2.4s" : "+w"(acc) : "w"(p), "w"(q));
    ZASSERT(acc[0] == 11 && acc[1] == 14 && acc[2] == 17 && acc[3] == 20);

    int32x4_t acc2 = {10, 10, 10, 10};
    asm volatile("mls %0.4s, %1.4s, %2.4s" : "+w"(acc2) : "w"(p), "w"(q));
    ZASSERT(acc2[0] == 0 && acc2[3] == -6);

    /* Vector tied float accumulate. */
    float32x4_t facc = {1.0f, 2.0f, 3.0f, 4.0f};
    float32x4_t fsrc = {1.0f, 2.0f, 3.0f, 4.0f};
    float32x4_t fp = {0.5f, 0.5f, 0.5f, 0.5f};
    asm volatile("fmla %0.4s, %1.4s, %2.4s" : "+w"(facc) : "w"(fsrc), "w"(fp));
    ZASSERT(facc[0] == 1.5f && facc[1] == 3.0f && facc[2] == 4.5f && facc[3] == 6.0f);

    /* movk building constants step by step. */
    unsigned long k = 0;
    asm volatile("movz %0, #0x4433, lsl #0" : "=r"(k));
    asm volatile("movk %0, #0x2211, lsl #16" : "+r"(k));
    asm volatile("movk %0, #0x8877, lsl #32" : "+r"(k));
    asm volatile("movk %0, #0xBBAA, lsl #48" : "+r"(k));
    ZASSERT(k == 0xBBAA887722114433UL);

    /* movn/movz. */
    unsigned long z;
    asm volatile("movn %0, #0" : "=r"(z));
    ZASSERT(z == 0xFFFFFFFFFFFFFFFFUL);

    asm volatile("movz %0, #0x1234, lsl #16" : "=r"(z));
    ZASSERT(z == 0x12340000UL);

    /* Tied with two separate inputs. */
    unsigned long t = 1000, u = 200, v = 30;
    asm volatile("msub %0, %1, %2, %0" : "+r"(t) : "r"(u), "r"(v));
    ZASSERT(t == (unsigned long)-5000L); /* t - u * v */
    return 0;
}
