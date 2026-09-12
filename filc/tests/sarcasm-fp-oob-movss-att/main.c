#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void f(void* p);

int main()
{
    float* buf = malloc(32);
    if (!buf)
        return 1;
    memset(buf, 0, 32);
    buf[0] = 1.0f;
    printf("setup ok\n");
    f(buf);   /* movss load at offset 30: reads [30,34), 2 bytes past the 32-byte object */
    printf("SHOULD NOT PRINT\n");
    return 0;
}
