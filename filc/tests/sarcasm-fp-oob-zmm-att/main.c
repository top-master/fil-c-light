#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void f(void* p);

int main()
{
    char* buf = malloc(64);
    if (!buf)
        return 1;
    memset(buf, 0, 64);
    printf("setup ok\n");
    f(buf);   /* vmovdqu64 load at offset 8: reads [8,72) past the 64-byte object */
    printf("SHOULD NOT PRINT\n");
    return 0;
}
