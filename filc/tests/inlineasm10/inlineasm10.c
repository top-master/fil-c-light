#include <stdfil.h>

int* allocx(void);

int main()
{
    int* x = allocx();
    int y;
    asm ("" : "=r"(y) : "0"(*x));
    ZASSERT(y == 666);
    return 0;
}

