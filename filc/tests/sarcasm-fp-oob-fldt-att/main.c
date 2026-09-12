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
    f(buf);   /* fldt load at offset 24: reads [24,34); an 8-byte check would pass */
    printf("SHOULD NOT PRINT\n");
    return 0;
}
