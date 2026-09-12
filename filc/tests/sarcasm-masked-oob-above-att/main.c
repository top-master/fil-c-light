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
    /* base = buf+8: only lane 0 is out of bounds at the top... lanes 0..6 are
       in bounds; the mask ALSO enables lane 7 (at buf+64, out of bounds). */
    f((char*)buf + 8, 0xFE);   /* lanes 1..7 */
    printf("SHOULD NOT PRINT\n");
    return 0;
}
