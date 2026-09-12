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
    /* eff = -4: a 16-byte load's naive eff+16 check wraps to 12 (<= upper)
       and passes, faulting the CPU on 0xfffffffffffffffc. */
    long idx = 0 - (size_t)buf - 4;
    f(buf, idx);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
