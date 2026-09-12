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
    /* 32-byte access at the end of the 32-byte object. */
    f(buf);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
