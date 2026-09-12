#include <stdio.h>
#include <stdlib.h>

long pseudo_save_restore(unsigned long *slot);

int main(void)
{
    unsigned long *slot = malloc(16);
    if (!slot)
        return 1;
    *slot = (unsigned long)slot;
    if (pseudo_save_restore(slot) != (long)slot) {
        printf("FAIL pseudo save restore\n");
        return 1;
    }
    printf("pseudo save restore ok\n");
    return 0;
}
