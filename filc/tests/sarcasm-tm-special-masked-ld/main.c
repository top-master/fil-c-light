#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdfil.h>

void f(void* p, long idx);

int main()
{
    char* buf = malloc(64);
    if (!buf)
        return 1;
    memset(buf, 0, 64);
    printf("setup ok\n");
    /* full mask on a special object: must trap. */
    zweak* w = zweak_new(buf);
    f((void*)w, 0xFFFF);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
