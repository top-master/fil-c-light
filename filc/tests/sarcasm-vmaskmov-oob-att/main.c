#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void f(void* p, long k);

int main()
{
    char* buf = malloc(32);
    if (!buf)
        return 1;
    memset(buf, 0, 32);
    printf("setup ok\n");
    /* ymm vmaskmovps load at buf-8 with an all-ones mask vector: lanes 0,1
       are out of bounds below the object. */
    f((char*)buf - 8, 0xFF);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
