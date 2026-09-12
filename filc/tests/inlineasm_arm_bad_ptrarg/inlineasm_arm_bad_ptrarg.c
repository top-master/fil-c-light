#include <stdfil.h>

int main(void)
{
    int obj = 1;
    int* p = &obj;
    unsigned long x;
    asm volatile("add %w0, %w1, %w1"
                 : "=r"(x)
                 : "r"(p));
    zprintf("not reached %lu\n", x);
    return 0;
}
