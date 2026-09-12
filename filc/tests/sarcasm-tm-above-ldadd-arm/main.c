#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void f(void* p, long v);

int main()
{
    char* buf = malloc(16);
    if (!buf)
        return 1;
    memset(buf, 0, 16);
    printf("setup ok\n");
    /* ldadd exactly at the upper bound */
    f(buf + 16, 1);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
