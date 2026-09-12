#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* A 4-byte s0 load 13 bytes into a 16-byte object covers [13, 17) — out of bounds. */
void loads(void* p);

int main()
{
    char* p = malloc(16);
    if (!p)
        return 1;
    memset(p, 0, 16);
    printf("expect trap:\n");
    fflush(stdout);
    loads(p + 13);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
