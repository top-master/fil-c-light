#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void f(void* p, long idx);

int main()
{
    char* buf = malloc(64);
    if (!buf)
        return 1;
    memset(buf, 0, 64);
    printf("setup ok\n");
    /* full mask on a freed object: must trap. */
    free(buf);
    f(buf, 0xFFFF);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
