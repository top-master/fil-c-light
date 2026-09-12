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
    f(buf + 60);   /* lfs load at end-4: reads [60,66); a 4-byte check would pass */
    printf("SHOULD NOT PRINT\n");
    return 0;
}
