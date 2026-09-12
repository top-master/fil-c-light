#include <stdfil.h>

int main()
{
    char* str = (char*)"hello";
    zprintf("(1) str = %s\n", str);
    __builtin_memcpy(str, "world", 5);
    zprintf("(2) str = %s\n", str);
    return 0;
}

