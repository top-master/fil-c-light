#include <stdfil.h>

typedef signed char v16qi __attribute__((vector_size(16)));
typedef unsigned char v16uqi __attribute__((vector_size(16)));
typedef short v8hi __attribute__((vector_size(16)));
typedef unsigned short v8uhi __attribute__((vector_size(16)));
typedef int v4si __attribute__((vector_size(16)));
typedef long long v2di __attribute__((vector_size(16)));

int main(void)
{
    /* PADDB: add packed bytes. */
    {
        v16qi a = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 };
        v16qi b = { 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1 };
        asm volatile("paddb %1, %0" : "+x"(a) : "x"(b));
        ZASSERT(a[0] == 17);
        ZASSERT(a[1] == 17);
        ZASSERT(a[15] == 17);
    }

    /* PADDW: add packed words. */
    {
        v8hi a = { 100, 200, 300, 400, 500, 600, 700, 800 };
        v8hi b = { 1, 2, 3, 4, 5, 6, 7, 8 };
        asm volatile("paddw %1, %0" : "+x"(a) : "x"(b));
        ZASSERT(a[0] == 101);
        ZASSERT(a[3] == 404);
        ZASSERT(a[7] == 808);
    }

    /* PADDD: add packed doublewords. */
    {
        v4si a = { 1000, 2000, 3000, 4000 };
        v4si b = { 1, 2, 3, 4 };
        asm volatile("paddd %1, %0" : "+x"(a) : "x"(b));
        ZASSERT(a[0] == 1001);
        ZASSERT(a[3] == 4004);
    }

    /* PADDQ: add packed quadwords. */
    {
        v2di a = { 1000000000LL, 2000000000LL };
        v2di b = { 1LL, 2LL };
        asm volatile("paddq %1, %0" : "+x"(a) : "x"(b));
        ZASSERT(a[0] == 1000000001LL);
        ZASSERT(a[1] == 2000000002LL);
    }

    /* PADDSB: add packed signed bytes with signed saturation. */
    {
        v16qi a = { 100, 100, -100, -100, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };
        v16qi b = { 100, 50, -100, -50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };
        asm volatile("paddsb %1, %0" : "+x"(a) : "x"(b));
        ZASSERT(a[0] == 127);    /* 100 + 100 = 200 saturates up */
        ZASSERT(a[1] == 127);    /* 100 + 50 = 150 saturates up */
        ZASSERT(a[2] == -128);   /* -100 + -100 = -200 saturates down */
        ZASSERT(a[3] == -128);   /* -100 + -50 = -150 saturates down */
        ZASSERT(a[4] == 2);
    }

    /* PADDSW: add packed signed words with signed saturation. */
    {
        v8hi a = { 30000, 30000, -30000, -30000, 1, 1, 1, 1 };
        v8hi b = { 30000, 10000, -30000, -10000, 1, 1, 1, 1 };
        asm volatile("paddsw %1, %0" : "+x"(a) : "x"(b));
        ZASSERT(a[0] == 32767);   /* 60000 saturates up */
        ZASSERT(a[1] == 32767);   /* 40000 saturates up */
        ZASSERT(a[2] == -32768);  /* -60000 saturates down */
        ZASSERT(a[3] == -32768);  /* -40000 saturates down */
        ZASSERT(a[4] == 2);
    }

    /* PADDUSB: add packed unsigned bytes with unsigned saturation. */
    {
        v16uqi a = { 200, 250, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };
        v16uqi b = { 100, 100, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };
        asm volatile("paddusb %1, %0" : "+x"(a) : "x"(b));
        ZASSERT(a[0] == 255);    /* 200 + 100 = 300 saturates up */
        ZASSERT(a[1] == 255);    /* 250 + 100 = 350 saturates up */
        ZASSERT(a[2] == 2);
    }

    /* PADDUSW: add packed unsigned words with unsigned saturation. */
    {
        v8uhi a = { 60000, 50000, 1, 1, 1, 1, 1, 1 };
        v8uhi b = { 10000, 20000, 1, 1, 1, 1, 1, 1 };
        asm volatile("paddusw %1, %0" : "+x"(a) : "x"(b));
        ZASSERT(a[0] == 65535);   /* 70000 saturates up */
        ZASSERT(a[1] == 65535);   /* 70000 saturates up */
        ZASSERT(a[2] == 2);
    }

    return 0;
}
