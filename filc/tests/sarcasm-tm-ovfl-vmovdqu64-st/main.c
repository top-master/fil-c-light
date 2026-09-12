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
    /* idx = -buf - 1 => eff = 2^64-1; eff+64 wraps to 63. */
    long idx = 0 - (size_t)buf - 1;
    f(buf, idx);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
