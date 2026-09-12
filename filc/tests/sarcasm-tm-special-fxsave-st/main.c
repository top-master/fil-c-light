#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdfil.h>

void f(void* p);

int main()
{
    char* buf = malloc(512);
    if (!buf)
        return 1;
    memset(buf, 0, 512);
    printf("setup ok\n");
    /* fxsave to a special (zweak) object. */
    zweak* w = zweak_new(buf);
    f((void*)w);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
