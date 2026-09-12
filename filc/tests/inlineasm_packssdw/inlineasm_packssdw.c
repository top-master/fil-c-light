#include <stdfil.h>

typedef int v4si __attribute__((vector_size(16)));
typedef short v8hi __attribute__((vector_size(16)));

int main(void)
{
    /* PACKSSDW: packs signed doublewords into signed words with saturation.
       First 4 words come from the destination (a), next 4 from the source (b). */
    union { v4si si; v8hi hi; } u;
    u.si = (v4si){ 100, -100, 70000, -70000 };
    v4si b = { 200, -200, 99999, -99999 };

    asm volatile("packssdw %1, %0" : "+x"(u.si) : "x"(b));

    ZASSERT(u.hi[0] == 100);
    ZASSERT(u.hi[1] == -100);
    ZASSERT(u.hi[2] == 32767);   /* 70000 saturates up */
    ZASSERT(u.hi[3] == -32768);  /* -70000 saturates down */
    ZASSERT(u.hi[4] == 200);
    ZASSERT(u.hi[5] == -200);
    ZASSERT(u.hi[6] == 32767);   /* 99999 saturates up */
    ZASSERT(u.hi[7] == -32768);  /* -99999 saturates down */

    return 0;
}
