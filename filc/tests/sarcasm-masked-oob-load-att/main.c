#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void f(void* p, long k);

int main()
{
    char* buf = malloc(64);
    if (!buf)
        return 1;
    memset(buf, 0, 64);
    printf("setup ok\n");
    /* masked load 64 bytes BELOW the object with all lanes enabled: every
       enabled lane is out of bounds. */
    f((char*)buf - 64, 0xFF);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
