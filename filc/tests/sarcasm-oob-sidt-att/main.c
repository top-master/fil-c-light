#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void f(void* p);

int main()
{
    char* buf = malloc(16);
    if (!buf)
        return 1;
    memset(buf, 0, 16);
    printf("setup ok\n");
    f(buf);   /* sidt store at offset 8: writes [8,18); an 8-byte check would pass */
    printf("SHOULD NOT PRINT\n");
    return 0;
}
