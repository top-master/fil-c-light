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
    /* vpexpandq load at buf+56 with popcount(mask) = 2: the accessed range is
       [56, 72), past the 64-byte object. */
    f((char*)buf + 56, 0x3);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
