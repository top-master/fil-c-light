#include <stdfil.h>
#include <string.h>

typedef int v8si __attribute__((vector_size(32)));

/* VPERMD (AVX2): permute doubleword elements of the data source (ymm3) using
 * 32-bit indices from the index source (ymm2), storing the result in ymm1.
 * Each index's low 3 bits select a dword from the data source (mod 8).
 *   VPERMD ymm1, ymm2(idx), ymm3/m256(data)
 * Intel order: dst, idx, data. AT&T order: data, idx, dst -> %2, %1, %0.
 */
__attribute__((target("avx2"))) int main(void)
{
    v8si data = { 10, 20, 30, 40, 50, 60, 70, 80 };

    /* Identity permutation: indices 0..7 select elements in order. */
    v8si idx = { 0, 1, 2, 3, 4, 5, 6, 7 };
    v8si dst = { 0 };
    asm volatile("vpermd %2, %1, %0" : "=x"(dst) : "x"(idx), "x"(data));
    ZASSERT(dst[0] == 10);
    ZASSERT(dst[1] == 20);
    ZASSERT(dst[2] == 30);
    ZASSERT(dst[3] == 40);
    ZASSERT(dst[4] == 50);
    ZASSERT(dst[5] == 60);
    ZASSERT(dst[6] == 70);
    ZASSERT(dst[7] == 80);

    /* Reverse permutation: indices 7..0. */
    idx = (v8si){ 7, 6, 5, 4, 3, 2, 1, 0 };
    asm volatile("vpermd %2, %1, %0" : "=x"(dst) : "x"(idx), "x"(data));
    ZASSERT(dst[0] == 80);
    ZASSERT(dst[1] == 70);
    ZASSERT(dst[2] == 60);
    ZASSERT(dst[3] == 50);
    ZASSERT(dst[4] == 40);
    ZASSERT(dst[5] == 30);
    ZASSERT(dst[6] == 20);
    ZASSERT(dst[7] == 10);

    /* Broadcast element 0: all indices 0. */
    idx = (v8si){ 0, 0, 0, 0, 0, 0, 0, 0 };
    asm volatile("vpermd %2, %1, %0" : "=x"(dst) : "x"(idx), "x"(data));
    ZASSERT(dst[0] == 10);
    ZASSERT(dst[1] == 10);
    ZASSERT(dst[2] == 10);
    ZASSERT(dst[3] == 10);
    ZASSERT(dst[4] == 10);
    ZASSERT(dst[5] == 10);
    ZASSERT(dst[6] == 10);
    ZASSERT(dst[7] == 10);

    return 0;
}
