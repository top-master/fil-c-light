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
    /* ldxr exactly at the upper bound */
    f(buf + 16);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
