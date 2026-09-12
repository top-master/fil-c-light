#include <stdfil.h>

int main()
{
    __builtin_memcpy(0, "hello", 5);
    zprintf("OK\n");
    return 0;
}
