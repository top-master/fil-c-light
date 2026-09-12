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
    /* 64-byte access one byte below the object. */
    f(buf);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
