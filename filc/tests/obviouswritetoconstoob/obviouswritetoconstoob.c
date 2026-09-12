#include <stdfil.h>

int main()
{
    char* str = (char*)"hello";
    zprintf("(1) str = %s\n", str);
    str[100] = 42;
    zprintf("(2) str = %s\n", str);
    return 0;
}

