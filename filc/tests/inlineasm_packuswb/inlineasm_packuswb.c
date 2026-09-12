#include <stdfil.h>

typedef short v8hi __attribute__((vector_size(16)));
typedef unsigned char v16qi __attribute__((vector_size(16)));

int main(void)
{
    /* PACKUSWB: packs signed words into unsigned bytes with saturation.
       First 8 bytes come from the destination (a), next 8 from the source (b).
       Negative values saturate to 0, values > 255 saturate to 255. */
    union { v8hi hi; v16qi qi; } u;
    u.hi = (v8hi){ 1, -2, 300, 0, 127, 255, 256, -100 };
    v8hi b = { 5, -5, 1000, 200, 50, 255, 0, -1 };

    asm volatile("packuswb %1, %0" : "+x"(u.hi) : "x"(b));

    ZASSERT(u.qi[0] == 1);
    ZASSERT(u.qi[1] == 0);    /* -2 saturates to 0 */
    ZASSERT(u.qi[2] == 255);  /* 300 saturates up */
    ZASSERT(u.qi[3] == 0);
    ZASSERT(u.qi[4] == 127);
    ZASSERT(u.qi[5] == 255);
    ZASSERT(u.qi[6] == 255);  /* 256 saturates up */
    ZASSERT(u.qi[7] == 0);    /* -100 saturates to 0 */
    ZASSERT(u.qi[8] == 5);
    ZASSERT(u.qi[9] == 0);    /* -5 saturates to 0 */
    ZASSERT(u.qi[10] == 255); /* 1000 saturates up */
    ZASSERT(u.qi[11] == 200);
    ZASSERT(u.qi[12] == 50);
    ZASSERT(u.qi[13] == 255);
    ZASSERT(u.qi[14] == 0);
    ZASSERT(u.qi[15] == 0);   /* -1 saturates to 0 */

    return 0;
}
