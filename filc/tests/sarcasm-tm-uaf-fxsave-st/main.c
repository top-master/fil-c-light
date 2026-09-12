#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void f(void* p);

int main()
{
    char* buf = malloc(512);
    if (!buf)
        return 1;
    memset(buf, 0, 512);
    printf("setup ok\n");
    /* fxsave to a freed object. */
    free(buf);
    f(buf);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
