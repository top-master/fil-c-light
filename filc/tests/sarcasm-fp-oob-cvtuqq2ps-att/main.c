#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void cvt_oob(void* p, void* at);

int main()
{
    char* buf = malloc(64);
    if (!buf)
        return 1;
    memset(buf, 0, 64);
    printf("setup ok\n");
    cvt_oob(buf, buf + 32);   /* 64-byte read at offset 32: only 32 bytes remain */
    printf("SHOULD NOT PRINT\n");
    return 0;
}
