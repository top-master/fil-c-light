#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void f(void* p);

int main()
{
    char* buf = malloc(512);
    if (!buf)
        return 1;
    memset(buf, 0, 512);
    printf("setup ok\n");
    /* 512-byte load at the end of the 512-byte object. */
    f(buf);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
