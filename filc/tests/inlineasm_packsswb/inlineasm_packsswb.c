#include <stdfil.h>

typedef short v8hi __attribute__((vector_size(16)));
typedef signed char v16qi __attribute__((vector_size(16)));

int main(void)
{
    /* PACKSSWB: packs signed words into signed bytes with saturation.
       First 8 bytes come from the destination (a), next 8 from the source (b). */
    union { v8hi hi; v16qi qi; } u;
    u.hi = (v8hi){ 1, -2, 300, -300, 127, -128, 128, -129 };
    v8hi b = { 5, -5, 1000, -1000, 50, -50, 255, -255 };

    asm volatile("packsswb %1, %0" : "+x"(u.hi) : "x"(b));

    ZASSERT(u.qi[0] == 1);
    ZASSERT(u.qi[1] == -2);
    ZASSERT(u.qi[2] == 127);    /* 300 saturates up */
    ZASSERT(u.qi[3] == -128);   /* -300 saturates down */
    ZASSERT(u.qi[4] == 127);
    ZASSERT(u.qi[5] == -128);
    ZASSERT(u.qi[6] == 127);    /* 128 saturates up */
    ZASSERT(u.qi[7] == -128);   /* -129 saturates down */
    ZASSERT(u.qi[8] == 5);
    ZASSERT(u.qi[9] == -5);
    ZASSERT(u.qi[10] == 127);   /* 1000 saturates up */
    ZASSERT(u.qi[11] == -128);  /* -1000 saturates down */
    ZASSERT(u.qi[12] == 50);
    ZASSERT(u.qi[13] == -50);
    ZASSERT(u.qi[14] == 127);   /* 255 saturates up */
    ZASSERT(u.qi[15] == -128);  /* -255 saturates down */

    return 0;
}
