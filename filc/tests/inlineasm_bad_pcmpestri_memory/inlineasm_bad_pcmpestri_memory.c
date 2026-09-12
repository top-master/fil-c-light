#include <stdfil.h>

typedef char v16qi __attribute__((vector_size(16)));

int main(void)
{
    v16qi a = { 0, 1, 2, 3, 4, 5, 6, 7,
                8, 9, 10, 11, 12, 13, 14, 15 };
    unsigned long p = 0;
    int res, la = 5, lb = 2;
    /* Memory operands are not supported in inline assembly. */
    asm volatile("pcmpestri $0x00, (%3), %1"
                 : "=c"(res) : "x"(a), "a"(la), "r"(p), "d"(lb) : "cc");
    return 0;
}
