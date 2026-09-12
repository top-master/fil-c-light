#include <stdfil.h>

int main(void)
{
    unsigned long r;

    /* ubfm/ubfx: extract unsigned field. */
    asm volatile("ubfm %0, %1, #8, #15" : "=r"(r) : "r"(0x12345678UL));
    ZASSERT(r == 0x56);

    asm volatile("ubfx %w0, %w1, #4, #8" : "=r"(r) : "r"(0x1230U));
    ZASSERT(r == 0x23);

    /* sbfm/sbfx: extract signed field. */
    asm volatile("sbfm %w0, %w1, #4, #31" : "=r"(r) : "r"(0xFFFFFF80U));
    ZASSERT(r == 0xFFFFFFF8U);

    asm volatile("sbfx %w0, %w1, #4, #8" : "=r"(r) : "r"(0x000000F0U));
    ZASSERT(r == 0x0FU); /* bits [11:4] = 0x0F, positive in 8 bits */

    asm volatile("sbfiz %x0, %x1, #0, #8" : "=r"(r) : "r"(0xFFUL));
    ZASSERT(r == 0xFFFFFFFFFFFFFFFFUL);

    asm volatile("ubfiz %x0, %x1, #8, #8" : "=r"(r) : "r"(0xABUL));
    ZASSERT(r == 0xAB00UL);

    /* bfi: insert field into a tied destination. */
    unsigned int d = 0;
    asm volatile("bfi %w0, %w1, #4, #8" : "+r"(d) : "r"(0xABU));
    ZASSERT(d == 0xAB0);

    d = 0xFFFF00FFU;
    asm volatile("bfi %w0, %w1, #8, #8" : "+r"(d) : "r"(0x12U));
    ZASSERT(d == 0xFFFF12FFU);

    /* bfxil: insert low bits of source into tied destination. */
    d = 0xABCDU;
    asm volatile("bfxil %w0, %w1, #8, #8" : "+r"(d) : "r"(0x1234U));
    ZASSERT(d == 0xAB12U);

    /* extr: extract from 128-bit pair. */
    unsigned long ea = 0x1234567890ABCDEFUL;
    unsigned long eb = 0x0F1E2D3C4B5A6978UL;
    unsigned long e;
    asm volatile("extr %0, %1, %2, #8" : "=r"(e) : "r"(ea), "r"(eb));
    {
        unsigned __int128 cat = ((unsigned __int128)ea << 64) | eb;
        ZASSERT(e == (unsigned long)(cat >> 8));
    }
    asm volatile("extr %0, %1, %2, #60" : "=r"(e) : "r"(ea), "r"(eb));
    {
        unsigned __int128 cat = ((unsigned __int128)ea << 64) | eb;
        ZASSERT(e == (unsigned long)(cat >> 60));
    }

    /* Extends. */
    int sv = -2;
    unsigned int uv = 0x80;
    unsigned int e32;
    asm volatile("sxtb %w0, %w1" : "=r"(e32) : "r"(uv));
    ZASSERT(e32 == 0xFFFFFF80U);

    asm volatile("uxtb %w0, %w1" : "=r"(e32) : "r"(uv));
    ZASSERT(e32 == 0x80);

    uv = 0x8000;
    asm volatile("sxth %w0, %w1" : "=r"(e32) : "r"(uv));
    ZASSERT(e32 == 0xFFFF8000U);

    asm volatile("uxth %w0, %w1" : "=r"(e32) : "r"(uv));
    ZASSERT(e32 == 0x8000);

    long e64;
    asm volatile("sxtw %x0, %w1" : "=r"(e64) : "r"((int)-5));
    ZASSERT(e64 == -5);

    asm volatile("uxtw %x0, %w1" : "=r"(e64) : "r"((int)-5));
    ZASSERT(e64 == 0xFFFFFFFBUL);

    asm volatile("sxtb %x0, %w1" : "=r"(e64) : "r"(0x7F));
    ZASSERT(e64 == 127);
    return 0;
}
