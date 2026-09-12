#include <stdfil.h>

int main(void)
{
    double d = 2.5;
    float f = 2.5f;
    unsigned long r;

    /* fcvt: double <-> single. */
    float fs;
    asm volatile("fcvt %s0, %d1" : "=w"(fs) : "w"(d));
    ZASSERT(fs == 2.5f);

    double ds;
    asm volatile("fcvt %d0, %s1" : "=w"(ds) : "w"(f));
    ZASSERT(ds == 2.5);

    /* fcvtzs/fcvtzu: truncate toward zero. */
    asm volatile("fcvtzs %w0, %s1" : "=r"(r) : "w"(2.9f));
    ZASSERT(r == 2);

    asm volatile("fcvtzs %w0, %d1" : "=r"(r) : "w"(-2.9));
    ZASSERT(r == 0xFFFFFFFEUL); /* writing a W register zero-extends */

    asm volatile("fcvtzu %w0, %d1" : "=r"(r) : "w"(3.9));
    ZASSERT(r == 3);

    asm volatile("fcvtzs %x0, %d1" : "=r"(r) : "w"(-2.9));
    ZASSERT(r == 0xFFFFFFFFFFFFFFFEUL);

    /* fcvtas/fcvtau: round to nearest, ties away. */
    asm volatile("fcvtas %w0, %d1" : "=r"(r) : "w"(2.5));
    ZASSERT(r == 3);

    asm volatile("fcvtas %w0, %d1" : "=r"(r) : "w"(-2.5));
    ZASSERT(r == 0xFFFFFFFDUL); /* zero-extended */

    asm volatile("fcvtau %w0, %d1" : "=r"(r) : "w"(2.5));
    ZASSERT(r == 3);

    /* fcvtms/fcvtmu: round toward -inf / +inf. */
    asm volatile("fcvtms %w0, %d1" : "=r"(r) : "w"(2.5));
    ZASSERT(r == 2);

    asm volatile("fcvtms %w0, %d1" : "=r"(r) : "w"(-2.5));
    ZASSERT(r == 0xFFFFFFFDUL); /* zero-extended */

    asm volatile("fcvtmu %w0, %d1" : "=r"(r) : "w"(2.9));
    ZASSERT(r == 2);

    /* fcvtns/fcvtnu: round to nearest even. */
    asm volatile("fcvtns %w0, %d1" : "=r"(r) : "w"(2.5));
    ZASSERT(r == 2);

    asm volatile("fcvtns %w0, %d1" : "=r"(r) : "w"(3.5));
    ZASSERT(r == 4);

    asm volatile("fcvtnu %w0, %d1" : "=r"(r) : "w"(2.5));
    ZASSERT(r == 2);

    /* fcvtps/fcvtpu: round toward +inf. */
    asm volatile("fcvtps %w0, %d1" : "=r"(r) : "w"(2.1));
    ZASSERT(r == 3);

    asm volatile("fcvtps %w0, %d1" : "=r"(r) : "w"(-2.1));
    ZASSERT(r == 0xFFFFFFFEUL); /* zero-extended */

    asm volatile("fcvtpu %w0, %d1" : "=r"(r) : "w"(2.1));
    ZASSERT(r == 3);

    /* scvtf/ucvtf: integer to floating point. */
    double out;
    asm volatile("scvtf %d0, %x1" : "=w"(out) : "r"(42L));
    ZASSERT(out == 42.0);

    asm volatile("ucvtf %d0, %x1" : "=w"(out) : "r"(0xFFFFFFFFFFFFFFFFUL));
    ZASSERT(out == 18446744073709551615.0);

    float outf;
    asm volatile("scvtf %s0, %w1" : "=w"(outf) : "r"(-3));
    ZASSERT(outf == -3.0f);

    asm volatile("ucvtf %s0, %w1" : "=w"(outf) : "r"(7U));
    ZASSERT(outf == 7.0f);

    /* frint family: round to integral value in place. */
    asm volatile("frintn %d0, %d1" : "=w"(out) : "w"(2.5));
    ZASSERT(out == 2.0);

    asm volatile("frintp %d0, %d1" : "=w"(out) : "w"(2.5));
    ZASSERT(out == 3.0);

    asm volatile("frintm %d0, %d1" : "=w"(out) : "w"(2.5));
    ZASSERT(out == 2.0);

    asm volatile("frintz %d0, %d1" : "=w"(out) : "w"(-2.5));
    ZASSERT(out == -2.0);

    asm volatile("frinta %d0, %d1" : "=w"(out) : "w"(2.5));
    ZASSERT(out == 3.0);

    asm volatile("frintx %d0, %d1" : "=w"(out) : "w"(2.5));
    ZASSERT(out == 2.0);

    asm volatile("frinti %d0, %d1" : "=w"(out) : "w"(2.5));
    ZASSERT(out == 2.0);
    return 0;
}
