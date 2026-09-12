#include <stdfil.h>
#include <smmintrin.h>

__attribute__((target("sse4.1"))) int main(void)
{
    __m128 a = _mm_setr_ps(1.0f, 2.0f, 3.0f, 4.0f);
    int r;

    asm volatile("extractps $2, %1, %0" : "=r"(r) : "x"(a));
    ZASSERT(r == 0x40400000);

    return 0;
}
