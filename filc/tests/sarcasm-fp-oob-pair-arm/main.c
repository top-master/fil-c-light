#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* A 16-byte d-pair load 8 bytes into a 16-byte object covers [8, 24) — out of bounds. */
void loadpair(void* p);

int main()
{
    char* p = malloc(16);
    if (!p)
        return 1;
    memset(p, 0, 16);
    printf("expect trap:\n");
    fflush(stdout);
    loadpair(p + 8);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
