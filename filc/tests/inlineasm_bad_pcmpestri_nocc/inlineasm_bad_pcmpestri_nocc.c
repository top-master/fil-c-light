#include <stdfil.h>

typedef char v16qi __attribute__((vector_size(16)));

int main(void)
{
    v16qi a = { 1, 2, 3, 4, 5, 6, 7, 8,
                9, 10, 11, 12, 13, 14, 15, 16 };
    v16qi b = { 1, 2, 3, 4, 5, 6, 7, 8,
                9, 10, 11, 12, 13, 14, 15, 16 };
    int la = 5, lb = 2, res;
    /* PCMPESTRI writes the flags, but no "cc" clobber is declared. */
    asm volatile("pcmpestri $0x00, %2, %1"
                 : "=c"(res) : "x"(a), "x"(b), "a"(la), "d"(lb));
    return 0;
}
