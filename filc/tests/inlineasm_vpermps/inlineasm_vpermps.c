#include <stdfil.h>
#include <string.h>

typedef float v8sf __attribute__((vector_size(32)));
typedef int v8si __attribute__((vector_size(32)));

/* VPERMPS (AVX2): permute single-precision values using indices from a second
 * YMM source. AVX2 provides only the variable register form:
 *   VPERMPS ymm1, ymm2(idx), ymm3/m256(data)
 * Intel order: dst, idx, data. AT&T order: data, idx, dst -> %2, %1, %0.
 * Each 32-bit index's low 3 bits select one of the 8 data elements. */
__attribute__((target("avx2"))) int main(void)
{
    v8sf data = { 10.0f, 20.0f, 30.0f, 40.0f, 50.0f, 60.0f, 70.0f, 80.0f };

    /* Identity: indices 0..7 select elements in order. */
    v8si idx = { 0, 1, 2, 3, 4, 5, 6, 7 };
    v8sf dst = { 0, 0, 0, 0, 0, 0, 0, 0 };
    asm volatile("vpermps %2, %1, %0" : "=x"(dst) : "x"(idx), "x"(data));
    ZASSERT(dst[0] == 10.0f);
    ZASSERT(dst[1] == 20.0f);
    ZASSERT(dst[2] == 30.0f);
    ZASSERT(dst[3] == 40.0f);
    ZASSERT(dst[4] == 50.0f);
    ZASSERT(dst[5] == 60.0f);
    ZASSERT(dst[6] == 70.0f);
    ZASSERT(dst[7] == 80.0f);

    /* Reverse: indices 7..0. */
    idx = (v8si){ 7, 6, 5, 4, 3, 2, 1, 0 };
    asm volatile("vpermps %2, %1, %0" : "=x"(dst) : "x"(idx), "x"(data));
    ZASSERT(dst[0] == 80.0f);
    ZASSERT(dst[1] == 70.0f);
    ZASSERT(dst[2] == 60.0f);
    ZASSERT(dst[3] == 50.0f);
    ZASSERT(dst[4] == 40.0f);
    ZASSERT(dst[5] == 30.0f);
    ZASSERT(dst[6] == 20.0f);
    ZASSERT(dst[7] == 10.0f);

    /* Broadcast element 0: all indices 0. */
    idx = (v8si){ 0, 0, 0, 0, 0, 0, 0, 0 };
    asm volatile("vpermps %2, %1, %0" : "=x"(dst) : "x"(idx), "x"(data));
    ZASSERT(dst[0] == 10.0f);
    ZASSERT(dst[1] == 10.0f);
    ZASSERT(dst[2] == 10.0f);
    ZASSERT(dst[3] == 10.0f);
    ZASSERT(dst[4] == 10.0f);
    ZASSERT(dst[5] == 10.0f);
    ZASSERT(dst[6] == 10.0f);
    ZASSERT(dst[7] == 10.0f);

    return 0;
}
