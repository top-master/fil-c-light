#include <stdio.h>

long symdelta(void);

int main(void)
{
    long d = symdelta();
    if (d != 64) {
        printf("symdelta mismatch: %ld\n", d);
        return 1;
    }
    printf("ok\n");
    return 0;
}
