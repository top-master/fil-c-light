#include <stdfil.h>
#include <arm_neon.h>

int main(void)
{
    /* Extra clobbers are respected: values the compiler keeps in those
       registers must survive across the asm. */
    long keep1 = 111;
    long keep2 = 222;
    long keep3 = 333;
    double keep4 = 4.5;

    asm volatile("mov x9, #999\n\t"
                 "mov x10, #888\n\t"
                 "mov x11, #777\n\t"
                 "fmov d8, #9.5\n\t"
                 "mov lr, xzr"
                 :
                 :
                 : "x9", "x10", "x11", "v8", "lr");

    ZASSERT(keep1 == 111);
    ZASSERT(keep2 == 222);
    ZASSERT(keep3 == 333);
    ZASSERT(keep4 == 4.5);

    /* The clobbered registers are usable as scratch space. */
    long r;
    asm volatile("mov x9, #3\n\t"
                 "mov x10, #4\n\t"
                 "mul %0, x9, x10\n\t"
                 "add %0, %0, #30"
                 : "=&r"(r)
                 :
                 : "x9", "x10");
    ZASSERT(r == 42);

    /* A vector clobber used as scratch. */
    float32x4_t fv;
    asm volatile("fmov %0.4s, #2.0\n\t"
                 "fadd %0.4s, %0.4s, %0.4s"
                 : "=w"(fv)
                 :
                 : );
    ZASSERT(fv[0] == 4.0f && fv[3] == 4.0f);

    double dv;
    asm volatile("fmov d8, #1.5\n\t"
                 "fmov %d0, d8"
                 : "=w"(dv)
                 :
                 : "v8");
    ZASSERT(dv == 1.5);

    /* Many clobbers at once, with live values around them. */
    long a = 1, b = 2, c = 3;
    asm volatile("mov x9, xzr\n\t"
                 "mov x10, xzr\n\t"
                 "mov x11, xzr\n\t"
                 "mov x12, xzr\n\t"
                 "mov x14, xzr\n\t"
                 "fmov d8, xzr\n\t"
                 "fmov d9, xzr\n\t"
                 "mov lr, xzr"
                 :
                 :
                 : "x9", "x10", "x11", "x12", "x14", "v8", "v9", "lr");
    ZASSERT(a == 1 && b == 2 && c == 3);
    return 0;
}
