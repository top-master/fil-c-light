#include <stdio.h>
#include <stdlib.h>

long cap_multi(unsigned long *a, unsigned long *b);

int main(void)
{
    unsigned long *a = malloc(16);
    unsigned long *b = malloc(16);
    if (!a || !b)
        return 1;
    *a = (unsigned long)a;
    *b = (unsigned long)b;
    /* a + b == (long)a + (long)b */
    if (cap_multi(a, b) != (long)a + (long)b) {
        printf("FAIL multi\n");
        return 1;
    }
    printf("cap multi ok\n");
    return 0;
}
