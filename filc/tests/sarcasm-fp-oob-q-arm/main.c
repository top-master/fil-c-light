#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* A 16-byte NEON q0 load 8 bytes into a 16-byte object covers [8, 24) — out of bounds. The access check must use the true 16-byte load width (an 8-byte check would pass). */
void loadq(void* p);

int main()
{
    char* p = malloc(16);
    if (!p)
        return 1;
    memset(p, 0, 16);
    printf("expect trap:\n");
    fflush(stdout);
    loadq(p + 8);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
