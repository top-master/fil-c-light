#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void f(void* p, long idx);

int main()
{
    char* buf = malloc(16);
    if (!buf)
        return 1;
    memset(buf, 0, 16);
    printf("setup ok\n");
    long idx = 0 - (size_t)buf - 1;
    /* idx = -buf - 1 => eff = 2^64-1; eff+2 wraps */
    f(buf, idx);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
