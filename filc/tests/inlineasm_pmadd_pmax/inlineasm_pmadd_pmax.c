#include <stdfil.h>

typedef signed char v16qi __attribute__((vector_size(16)));
typedef unsigned char v16uqi __attribute__((vector_size(16)));
typedef short v8hi __attribute__((vector_size(16)));
typedef unsigned short v8uhi __attribute__((vector_size(16)));
typedef int v4si __attribute__((vector_size(16)));
typedef unsigned int v4usi __attribute__((vector_size(16)));

int main(void)
{
    /* PMADDUBSW: dest(src1) holds unsigned bytes, src(src2) holds signed bytes.
       Each adjacent pair produces a signed 16-bit sum of products, saturated. */
    {
        v16uqi a = { 2, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };
        v16qi b = { 3, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };
        asm volatile("pmaddubsw %1, %0" : "+x"(a) : "x"(b));
        union { v16uqi u; v8hi h; } cv;
        cv.u = a;
        ZASSERT(cv.h[0] == 2 * 3 + 4 * 5);  /* 26 */
        ZASSERT(cv.h[1] == 1 * 1 + 1 * 1);  /* 2 */
        ZASSERT(cv.h[7] == 2);
    }

    /* PMADDUBSW saturation: large unsigned * large signed overflows signed word. */
    {
        v16uqi a = { 255, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
        v16qi b = { 127, 127, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
        asm volatile("pmaddubsw %1, %0" : "+x"(a) : "x"(b));
        union { v16uqi u; v8hi h; } cv;
        cv.u = a;
        /* 255*127 + 255*127 = 64770, which saturates to 32767. */
        ZASSERT(cv.h[0] == 32767);
    }

    /* PMADDWD: signed words of dest * signed words of src, adjacent pairs summed
       into signed 32-bit doublewords. */
    {
        v8hi a = { 2, 4, 1, 1, 1, 1, 1, 1 };
        v8hi b = { 3, 5, 1, 1, 1, 1, 1, 1 };
        asm volatile("pmaddwd %1, %0" : "+x"(a) : "x"(b));
        union { v8hi h; v4si s; } cv;
        cv.h = a;
        ZASSERT(cv.s[0] == 2 * 3 + 4 * 5);  /* 26 */
        ZASSERT(cv.s[1] == 1 * 1 + 1 * 1);  /* 2 */
        ZASSERT(cv.s[3] == 2);
    }

    /* PMAXSB: packed maximum of signed bytes. */
    {
        v16qi a = { 1, -5, 100, -100, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };
        v16qi b = { 3, 2, -10, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };
        asm volatile("pmaxsb %1, %0" : "+x"(a) : "x"(b));
        ZASSERT(a[0] == 3);
        ZASSERT(a[1] == 2);
        ZASSERT(a[2] == 100);
        ZASSERT(a[3] == 5);
    }

    /* PMAXSW: packed maximum of signed words. */
    {
        v8hi a = { -30000, 1000, 1, 1, 1, 1, 1, 1 };
        v8hi b = { 30000, -1000, 1, 1, 1, 1, 1, 1 };
        asm volatile("pmaxsw %1, %0" : "+x"(a) : "x"(b));
        ZASSERT(a[0] == 30000);
        ZASSERT(a[1] == 1000);
    }

    /* PMAXSD: packed maximum of signed doublewords. */
    {
        v4si a = { -1000000, 5, 1, 1 };
        v4si b = { 1000000, -5, 1, 1 };
        asm volatile("pmaxsd %1, %0" : "+x"(a) : "x"(b));
        ZASSERT(a[0] == 1000000);
        ZASSERT(a[1] == 5);
    }

    /* PMAXUB: packed maximum of unsigned bytes. */
    {
        v16uqi a = { 200, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };
        v16uqi b = { 100, 250, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };
        asm volatile("pmaxub %1, %0" : "+x"(a) : "x"(b));
        ZASSERT(a[0] == 200);
        ZASSERT(a[1] == 250);
    }

    /* PMAXUW: packed maximum of unsigned words. */
    {
        v8uhi a = { 10, 60000, 1, 1, 1, 1, 1, 1 };
        v8uhi b = { 20, 5, 1, 1, 1, 1, 1, 1 };
        asm volatile("pmaxuw %1, %0" : "+x"(a) : "x"(b));
        ZASSERT(a[0] == 20);
        ZASSERT(a[1] == 60000);
    }

    /* PMAXUD: packed maximum of unsigned doublewords. */
    {
        v4usi a = { 1u, 4000000000u, 1u, 1u };
        v4usi b = { 2u, 1u, 1u, 1u };
        asm volatile("pmaxud %1, %0" : "+x"(a) : "x"(b));
        ZASSERT(a[0] == 2u);
        ZASSERT(a[1] == 4000000000u);
    }

    return 0;
}
