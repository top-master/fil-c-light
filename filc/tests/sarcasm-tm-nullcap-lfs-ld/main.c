#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void f(void* p);

int main()
{
    printf("setup ok\n");
    /* lfs through an integer address (null capability). */
    f((void*)0x12345);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
