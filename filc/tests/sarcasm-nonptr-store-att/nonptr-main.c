#include <stdio.h>
#include <stdlib.h>

void f(unsigned long* p);

int main()
{
    unsigned long* p = (unsigned long*)malloc(8192);
    p[0] = 0x1234;
    printf("setup ok\n");
    /* The stored VALUE is a valid pointer; the BASE is the integer 8192. */
    f(p);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
