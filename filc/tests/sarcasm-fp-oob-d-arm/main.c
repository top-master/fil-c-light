#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* An 8-byte d0 load 12 bytes into a 16-byte object covers [12, 20) — out of bounds. */
void loadd(void* p);

int main()
{
    char* p = malloc(16);
    if (!p)
        return 1;
    memset(p, 0, 16);
    printf("expect trap:\n");
    fflush(stdout);
    loadd(p + 12);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
