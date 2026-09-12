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
    f(buf);   /* vstmxcsr store at offset 14: writes [14,18), straddling the 16-byte upper bound */
    printf("SHOULD NOT PRINT\n");
    return 0;
}
