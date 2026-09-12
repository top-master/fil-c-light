#include <stdio.h>
#include <stdlib.h>

/* `;! atomic load ptr` at buf+4: misaligned for a pointer load. */
void* h(void** p);

int main()
{
    char* buf = malloc(64);
    printf("expect trap:\n");
    fflush(stdout);
    h((void**)(buf + 4));
    printf("SHOULD NOT PRINT\n");
    return 0;
}
