#include <stdfil.h>
extern char *strstr (const char *, const char *) __asm ("my_strstr");
char* a = "hello";
char* b = "world";
int main()
{
    zprintf("result = %s\n", strstr(a, b));
    return 0;
}
