#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void f(void* p);

int main()
{
    char* buf = malloc(32);
    if (!buf)
        return 1;
    memset(buf, 0, 32);
    printf("setup ok\n");
    f(buf);   /* MMX movq load at offset 28: reads [28,36); a 4-byte check would pass */
    printf("SHOULD NOT PRINT\n");
    return 0;
}
