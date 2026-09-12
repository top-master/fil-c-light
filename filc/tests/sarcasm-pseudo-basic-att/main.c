#include <stdio.h>

long pseudo_basic(long a, long b, long c);
long pseudo_kill(long a);

int main(void)
{
    if (pseudo_basic(1, 2, 3) != 6) {
        printf("FAIL basic\n");
        return 1;
    }
    if (pseudo_kill(5) != 12) {
        printf("FAIL kill\n");
        return 1;
    }
    printf("pseudo basic ok\n");
    return 0;
}
