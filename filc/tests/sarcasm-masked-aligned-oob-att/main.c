#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void f(void* p, long k);

int main()
{
    char* buf = malloc(80);
    if (!buf)
        return 1;
    memset(buf, 0, 80);
    printf("setup ok\n");
    /* vmovdqa32 {%k1} at buf+8: in bounds and 8-byte aligned, but NOT
       vector-aligned — sarcasm's clamped-to-8 alignment check passes it and
       the CPU #GPs... no: use buf+4, which fails the clamped-to-8 check
       cleanly. */
    f((char*)buf + 4, 0xFF);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
