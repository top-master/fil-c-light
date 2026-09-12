#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* The 1-byte b0 load at offset 15 of a 16-byte object is in bounds, but the 2-byte h0 load at the same offset covers [15, 17) — out of bounds. */
void loadbh(void* p);

int main()
{
    char* p = malloc(16);
    if (!p)
        return 1;
    memset(p, 0, 16);
    printf("expect trap:\n");
    fflush(stdout);
    loadbh(p + 15);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
