#include <stdfil.h>

typedef unsigned char v16uqi __attribute__((vector_size(16)));
typedef unsigned short v8uhi __attribute__((vector_size(16)));
typedef unsigned int v4usi __attribute__((vector_size(16)));
typedef unsigned long long v2udi __attribute__((vector_size(16)));

int main(void)
{
    /* PINSRB: insert low byte of r32 into xmm at byte offset imm8[3:0]. */
    {
        v16uqi v = { 0, 0, 0, 0, 0, 0, 0, 0,
                     0, 0, 0, 0, 0, 0, 0, 0 };
        unsigned int src = 0xEE;
        asm volatile("pinsrb $3, %1, %0" : "+x"(v) : "r"(src));
        ZASSERT(v[0] == 0);
        ZASSERT(v[3] == 0xEE);
        ZASSERT(v[15] == 0);
        /* imm8[3:0] masks, so $16 wraps to offset 0. */
        asm volatile("pinsrb $16, %1, %0" : "+x"(v) : "r"(src));
        ZASSERT(v[0] == 0xEE);
        ZASSERT(v[3] == 0xEE);
    }

    /* PINSRD: insert dword from r32 into xmm at dword offset imm8[1:0]. */
    {
        v4usi v = { 0, 0, 0, 0 };
        unsigned int src = 0xDEADBEEFu;
        asm volatile("pinsrd $1, %1, %0" : "+x"(v) : "r"(src));
        ZASSERT(v[0] == 0);
        ZASSERT(v[1] == 0xDEADBEEFu);
        ZASSERT(v[2] == 0);
        ZASSERT(v[3] == 0);
        /* imm8[1:0] masks, so $4 wraps to offset 0. */
        asm volatile("pinsrd $4, %1, %0" : "+x"(v) : "r"(src));
        ZASSERT(v[0] == 0xDEADBEEFu);
    }

    /* PINSRQ: insert qword from r64 into xmm at qword offset imm8[0]. */
    {
        v2udi v = { 0, 0 };
        unsigned long long src = 0x1122334455667788ULL;
        asm volatile("pinsrq $1, %1, %0" : "+x"(v) : "r"(src));
        ZASSERT(v[0] == 0);
        ZASSERT(v[1] == 0x1122334455667788ULL);
        /* imm8[0] masks, so $2 wraps to offset 0. */
        asm volatile("pinsrq $2, %1, %0" : "+x"(v) : "r"(src));
        ZASSERT(v[0] == 0x1122334455667788ULL);
    }

    /* PINSRW: insert low word of r32 into xmm at word offset imm8[3:0]. */
    {
        v8uhi v = { 0, 0, 0, 0, 0, 0, 0, 0 };
        unsigned int src = 0xBEEF;
        asm volatile("pinsrw $2, %1, %0" : "+x"(v) : "r"(src));
        ZASSERT(v[0] == 0);
        ZASSERT(v[2] == 0xBEEF);
        ZASSERT(v[7] == 0);
        /* imm8[3:0] masks, so $8 wraps to offset 0. */
        asm volatile("pinsrw $8, %1, %0" : "+x"(v) : "r"(src));
        ZASSERT(v[0] == 0xBEEF);
    }

    return 0;
}
