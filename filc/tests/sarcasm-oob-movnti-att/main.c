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
    f(buf);   /* movnti 8-byte store at offset 12: writes [12,20), past the 16-byte upper bound */
    printf("SHOULD NOT PRINT\n");
    return 0;
}
