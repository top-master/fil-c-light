#include <stdfil.h>

typedef int v4si __attribute__((vector_size(16)));
typedef unsigned short v8hi __attribute__((vector_size(16)));

int main(void)
{
    /* PACKUSDW: packs signed doublewords into unsigned words with saturation.
       First 4 words come from the destination (a), next 4 from the source (b).
       Negative values saturate to 0, values > 65535 saturate to 65535. */
    union { v4si si; v8hi hi; } u;
    u.si = (v4si){ 100, -100, 70000, 0 };
    v4si b = { 200, -200, 99999, 65535 };

    asm volatile("packusdw %1, %0" : "+x"(u.si) : "x"(b));

    ZASSERT(u.hi[0] == 100);
    ZASSERT(u.hi[1] == 0);      /* -100 saturates to 0 */
    ZASSERT(u.hi[2] == 65535);  /* 70000 saturates up */
    ZASSERT(u.hi[3] == 0);
    ZASSERT(u.hi[4] == 200);
    ZASSERT(u.hi[5] == 0);      /* -200 saturates to 0 */
    ZASSERT(u.hi[6] == 65535);  /* 99999 saturates up */
    ZASSERT(u.hi[7] == 65535);

    return 0;
}
