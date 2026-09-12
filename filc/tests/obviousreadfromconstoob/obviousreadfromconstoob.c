#include <stdfil.h>

int main()
{
    char* str = (char*)"hello";
    zprintf("(1) str = %s\n", str);
    zprintf("str[100] = %c\n", str[100]);
    zprintf("(2) str = %s\n", str);
    return 0;
}

