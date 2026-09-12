#include <stdfil.h>

typedef unsigned char v16uqi __attribute__((vector_size(16)));
typedef unsigned short v8uhi __attribute__((vector_size(16)));
typedef unsigned int v4usi __attribute__((vector_size(16)));
typedef unsigned long long v2udi __attribute__((vector_size(16)));

int main(void)
{
    /* PEXTRB: extract a byte from xmm at byte offset imm8[3:0], zero-extend. */
    {
        v16uqi v = { 10, 20, 30, 40, 50, 60, 70, 80,
                     90, 100, 110, 120, 130, 140, 150, 160 };
        unsigned long r;
        asm volatile("pextrb $0, %1, %0" : "=r"(r) : "x"(v));
        ZASSERT(r == 10);
        asm volatile("pextrb $3, %1, %0" : "=r"(r) : "x"(v));
        ZASSERT(r == 40);
        asm volatile("pextrb $15, %1, %0" : "=r"(r) : "x"(v));
        ZASSERT(r == 160);
        /* imm8[3:0] masks the index, so $16 wraps to offset 0. */
        asm volatile("pextrb $16, %1, %0" : "=r"(r) : "x"(v));
        ZASSERT(r == 10);
    }

    /* PEXTRD: extract a dword from xmm at dword offset imm8[1:0]. */
    {
        v4usi v = { 0x11111111u, 0x22222222u, 0x33333333u, 0x44444444u };
        unsigned int r;
        asm volatile("pextrd $0, %1, %0" : "=r"(r) : "x"(v));
        ZASSERT(r == 0x11111111u);
        asm volatile("pextrd $1, %1, %0" : "=r"(r) : "x"(v));
        ZASSERT(r == 0x22222222u);
        asm volatile("pextrd $3, %1, %0" : "=r"(r) : "x"(v));
        ZASSERT(r == 0x44444444u);
        /* imm8[1:0] masks, so $4 wraps to offset 0. */
        asm volatile("pextrd $4, %1, %0" : "=r"(r) : "x"(v));
        ZASSERT(r == 0x11111111u);
    }

    /* PEXTRQ: extract a qword from xmm at qword offset imm8[0]. */
    {
        v2udi v = { 0x1122334455667788ULL, 0x99aabbccddeeff00ULL };
        unsigned long long r;
        asm volatile("pextrq $0, %1, %0" : "=r"(r) : "x"(v));
        ZASSERT(r == 0x1122334455667788ULL);
        asm volatile("pextrq $1, %1, %0" : "=r"(r) : "x"(v));
        ZASSERT(r == 0x99aabbccddeeff00ULL);
        /* imm8[0] masks, so $2 wraps to offset 0. */
        asm volatile("pextrq $2, %1, %0" : "=r"(r) : "x"(v));
        ZASSERT(r == 0x1122334455667788ULL);
    }

    /* PEXTRW: extract a word from xmm at word offset imm8[3:0], zero-extend. */
    {
        v8uhi v = { 0x0001, 0x0203, 0x0405, 0x0607,
                    0x0809, 0x0a0b, 0x0c0d, 0x0e0f };
        unsigned int r;
        asm volatile("pextrw $0, %1, %0" : "=r"(r) : "x"(v));
        ZASSERT(r == 0x0001);
        asm volatile("pextrw $1, %1, %0" : "=r"(r) : "x"(v));
        ZASSERT(r == 0x0203);
        asm volatile("pextrw $7, %1, %0" : "=r"(r) : "x"(v));
        ZASSERT(r == 0x0e0f);
        /* imm8[3:0] masks, so $8 wraps to offset 0. */
        asm volatile("pextrw $8, %1, %0" : "=r"(r) : "x"(v));
        ZASSERT(r == 0x0001);
    }

    return 0;
}
