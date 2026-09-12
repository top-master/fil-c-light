#include <stdfil.h>

typedef unsigned char v16uqi __attribute__((vector_size(16)));

int main(void)
{
    v16uqi v = { 1, 2, 3, 4, 5, 6, 7, 8,
                 9, 10, 11, 12, 13, 14, 15, 16 };
    unsigned long p = 0;
    /* PEXTRB with a memory destination: not allowed in safe inline asm. */
    asm volatile("pextrb $0, %1, (%0)" : : "r"(p), "x"(v));
    return 0;
}
