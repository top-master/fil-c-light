#include <stdfil.h>

int main(void)
{
    unsigned int crc;
    unsigned char b;

    crc = 0;
    b = 0x00;
    asm volatile("crc32b %1, %0"
                 : "+r"(crc)
                 : "r"(b)
                 : "cc");
    ZASSERT(crc == 0x00000000);

    crc = 0;
    b = 0x01;
    asm volatile("crc32b %1, %0"
                 : "+r"(crc)
                 : "r"(b)
                 : "cc");
    ZASSERT(crc == 0xf26b8303);

    unsigned long crc64;
    unsigned long val;

    crc64 = 0;
    val = 0;
    asm volatile("crc32q %1, %0"
                 : "+r"(crc64)
                 : "r"(val)
                 : "cc");
    ZASSERT(crc64 == 0);

    crc64 = 0;
    val = 0x0102030405060708ULL;
    asm volatile("crc32q %1, %0"
                 : "+r"(crc64)
                 : "r"(val)
                 : "cc");
    ZASSERT(crc64 == 0x00000000aad1b096ULL);

    return 0;
}
