#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* An st4 .4s four-structure store writes 64 bytes; 8 bytes into a 64-byte object it covers [8, 72) — out of bounds. */
void storest4(void* p);

int main()
{
    char* p = malloc(64);
    if (!p)
        return 1;
    memset(p, 0, 64);
    printf("expect trap:\n");
    fflush(stdout);
    storest4(p + 8);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
