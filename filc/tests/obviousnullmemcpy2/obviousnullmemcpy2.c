#include <stdfil.h>

int main()
{
    char buf[5];
    __builtin_memcpy(buf, 0, 5);
    zprintf("OK\n");
    return 0;
}
