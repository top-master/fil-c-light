#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void f(void* p);

int main()
{
    char* buf = malloc(32);
    if (!buf)
        return 1;
    memset(buf, 0, 32);
    printf("setup ok\n");
    f(buf);   /* movsd store at offset 28: writes [28,36), straddling the 32-byte upper bound */
    printf("SHOULD NOT PRINT\n");
    return 0;
}
