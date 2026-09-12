#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void f(void* p, long idx);

int main()
{
    char* buf = malloc(512);
    if (!buf)
        return 1;
    memset(buf, 0, 512);
    printf("setup ok\n");
    /* idx = -buf - 16 => eff = 2^64-16 (16-aligned); eff+512 wraps. */
    long idx = 0 - (size_t)buf - 16;
    f(buf, idx);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
