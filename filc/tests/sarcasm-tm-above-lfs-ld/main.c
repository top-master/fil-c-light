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
    /* 6-byte far-pointer load at the end of the 16-byte object. */
    f(buf);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
