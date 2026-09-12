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
    /* vpcompressq store at buf-8 with a nonzero mask: the contiguous access
       starts below the object (any nonzero popcount range starts at eff). */
    f((char*)buf - 8, 0x1);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
