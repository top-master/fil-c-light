#include <stdfil.h>

typedef char v16qi __attribute__((vector_size(16)));

int main(void)
{
    v16qi d = { 100, 101, 102, 103, 104, 105, 106, 107,
                108, 109, 110, 111, 112, 113, 114, 115 };
    v16qi s = { 0, 1, 2, 3, 4, 5, 6, 7,
                8, 9, 10, 11, 12, 13, 14, 15 };
    /* PALIGNR concatenates dest:src (256-bit) and shifts right by imm bytes. */
    asm volatile("palignr $4, %1, %0" : "+x"(d) : "x"(s));
    ZASSERT(d[0] == 4);
    ZASSERT(d[1] == 5);
    ZASSERT(d[2] == 6);
    ZASSERT(d[3] == 7);
    ZASSERT(d[4] == 8);
    ZASSERT(d[5] == 9);
    ZASSERT(d[6] == 10);
    ZASSERT(d[7] == 11);
    ZASSERT(d[8] == 12);
    ZASSERT(d[9] == 13);
    ZASSERT(d[10] == 14);
    ZASSERT(d[11] == 15);
    ZASSERT(d[12] == 100);
    ZASSERT(d[13] == 101);
    ZASSERT(d[14] == 102);
    ZASSERT(d[15] == 103);
    return 0;
}
