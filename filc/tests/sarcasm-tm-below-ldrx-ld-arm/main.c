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
    /* 8-byte access 8 byte(s) below the object */
    f(buf);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
