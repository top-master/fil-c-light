#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void f(void* p);

int main()
{
    char* buf = malloc(16);
    if (!buf)
        return 1;
    memset(buf, 0, 16);
    printf("setup ok\n");
    /* 64-byte st4 store partially past the upper bound */
    f(buf + 8);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
