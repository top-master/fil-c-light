#include <stdfil.h>

int main(void)
{
    unsigned long cf;
    unsigned long val;

    cf = 0;
    val = 2;
    asm volatile("bts $1, %1\n\tadc $0, %0"
                 : "+r"(cf), "+r"(val)
                 :
                 : "cc");
    ZASSERT(cf == 1);
    ZASSERT(val == 2);

    cf = 0;
    val = 4;
    asm volatile("bts $2, %1\n\tadc $0, %0"
                 : "+r"(cf), "+r"(val)
                 :
                 : "cc");
    ZASSERT(cf == 1);
    ZASSERT(val == 4);

    cf = 0;
    val = 0;
    asm volatile("bts $0, %1\n\tadc $0, %0"
                 : "+r"(cf), "+r"(val)
                 :
                 : "cc");
    ZASSERT(cf == 0);
    ZASSERT(val == 1);

    cf = 0;
    val = 0x8000000000000000ull;
    asm volatile("btsq $63, %1\n\tadc $0, %0"
                 : "+r"(cf), "+r"(val)
                 :
                 : "cc");
    ZASSERT(cf == 1);
    ZASSERT(val == 0x8000000000000000ull);

    cf = 0;
    val = 1;
    unsigned long bit = 0;
    asm volatile("bts %2, %1\n\tadc $0, %0"
                 : "+r"(cf), "+r"(val)
                 : "r"(bit)
                 : "cc");
    ZASSERT(cf == 1);
    ZASSERT(val == 1);

    unsigned int cf32 = 0;
    unsigned int val32 = 0x80000000u;
    asm volatile("btsl $31, %1\n\tadc $0, %0"
                 : "+r"(cf32), "+r"(val32)
                 :
                 : "cc");
    ZASSERT(cf32 == 1);
    ZASSERT(val32 == 0x80000000u);

    cf = 0;
    val = 0xffffffffffffffffull;
    asm volatile("btsq $63, %1\n\tadc $0, %0"
                 : "+r"(cf), "+r"(val)
                 :
                 : "cc");
    ZASSERT(cf == 1);
    ZASSERT(val == 0xffffffffffffffffull);

    return 0;
}
