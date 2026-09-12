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
    /* idx = -buf - 8 => eff = buf + idx = -8 = 0xfffffffffffffff8: the 8-byte
       access's eff+8 wraps to 0, so a naive eff+size check would pass. */
    long idx = 0 - (size_t)buf - 8;
    f(buf, idx);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
