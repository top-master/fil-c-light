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
    /* eff = -8: an 8-byte STORE's naive eff+8 check wraps to 0 and passes. */
    long idx = 0 - (size_t)buf - 8;
    f(buf, idx);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
