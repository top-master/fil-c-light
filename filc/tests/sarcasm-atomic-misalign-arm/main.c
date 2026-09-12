#include <stdio.h>
#include <stdlib.h>

/* ldadd at buf+4: misaligned for the 8-byte atomic. */
void f(long* p, long v);

int main()
{
    char* buf = malloc(64);
    printf("expect trap:\n");
    fflush(stdout);
    f((long*)(buf + 4), 1);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
