#include <stdio.h>
#include <stdlib.h>

/* casp at buf+8 of a 32-byte object: 8-aligned but not 16, so the 16-byte
   natural-alignment check must fire. */
void g(void* p);

int main()
{
    char* buf = malloc(32);
    printf("expect trap:\n");
    fflush(stdout);
    g(buf + 8);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
