#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void pminsd_oob(void* p, void* at);

int main()
{
    char* buf = malloc(64);
    if (!buf)
        return 1;
    memset(buf, 0, 64);
    printf("setup ok\n");
    pminsd_oob(buf, buf + 56);   /* 16-byte read at offset 56: only 8 bytes remain */
    printf("SHOULD NOT PRINT\n");
    return 0;
}
