#include <stdio.h>
#include <stdlib.h>

unsigned long and_zero_trap(unsigned long *p);

int main(void)
{
    unsigned long *p = malloc(64);
    if (!p)
        return 1;
    p[0] = 42;
    printf("expect trap:\n");
    printf("%lu SHOULD NOT PRINT\n", and_zero_trap(p));
    return 0;
}
