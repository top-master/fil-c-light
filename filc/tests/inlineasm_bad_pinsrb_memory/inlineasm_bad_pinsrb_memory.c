#include <stdfil.h>

typedef unsigned char v16uqi __attribute__((vector_size(16)));

int main(void)
{
    v16uqi v = { 0, 0, 0, 0, 0, 0, 0, 0,
                 0, 0, 0, 0, 0, 0, 0, 0 };
    unsigned long p = 0;
    /* PINSRB with a memory source: not allowed in safe inline asm. */
    asm volatile("pinsrb $0, (%1), %0" : "+x"(v) : "r"(p));
    return 0;
}
