#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* The 2-byte fp16 h0 store at offset 15 of a 16-byte object covers [15, 17) — out of bounds. */
void storeh(void* p);

int main()
{
    char* p = malloc(16);
    if (!p)
        return 1;
    memset(p, 0, 16);
    printf("expect trap:\n");
    fflush(stdout);
    storeh(p);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
