#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdfil.h>

void f(void* p);

int main()
{
    char* buf = malloc(16);
    if (!buf)
        return 1;
    memset(buf, 0, 16);
    printf("setup ok\n");
    /* the zweak object itself is special: any access must trap. */
    zweak* w = zweak_new(buf);
    f((void*)w);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
