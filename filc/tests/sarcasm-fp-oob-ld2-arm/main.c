#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* An ld2 .16b two-structure load reads 32 bytes; 8 bytes into a 32-byte object it covers [8, 40) — out of bounds. */
void loadld2(void* p);

int main()
{
    char* p = malloc(32);
    if (!p)
        return 1;
    memset(p, 0, 32);
    printf("expect trap:\n");
    fflush(stdout);
    loadld2(p + 8);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
