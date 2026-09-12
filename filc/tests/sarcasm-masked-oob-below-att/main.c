#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void f(void* p, long k);

int main()
{
    char* buf = malloc(64);
    if (!buf)
        return 1;
    memset(buf, 0, 64);
    printf("setup ok\n");
    /* base = buf-16: lanes 2..7 are in bounds, but the mask ALSO enables
       lane 0 (at buf-16, out of bounds) — must trap. */
    f((char*)buf - 16, 0xFD);   /* lanes 0,2,3,4,5,6,7 */
    printf("SHOULD NOT PRINT\n");
    return 0;
}
