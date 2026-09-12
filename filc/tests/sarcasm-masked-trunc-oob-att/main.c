#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void f(void* p, long k);

int main()
{
    char* buf = malloc(16);
    if (!buf)
        return 1;
    memset(buf, 0, 16);
    printf("setup ok\n");
    /* vpmovqb zmm -> 8 bytes at buf+9 with all 8 lanes enabled: the footprint
       [9, 17) is out of bounds (lane 7 at buf+16). */
    f((char*)buf + 9, 0xFF);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
