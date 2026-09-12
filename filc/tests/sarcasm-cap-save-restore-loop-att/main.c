#include <stdio.h>
#include <stdlib.h>

long cap_loop(unsigned long *slot, unsigned long n);

int main(void)
{
    unsigned long *slot = malloc(16);
    if (!slot)
        return 1;
    *slot = (unsigned long)slot;
    if (cap_loop(slot, 5) != (long)slot) {
        printf("FAIL loop\n");
        return 1;
    }
    printf("cap loop ok\n");
    return 0;
}
