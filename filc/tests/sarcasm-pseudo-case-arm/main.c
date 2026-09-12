#include <stdio.h>

long pseudo_casediff(long a, long b);

int main(void)
{
    if (pseudo_casediff(100, 30) != 70) {
        printf("FAIL casediff\n");
        return 1;
    }
    if (pseudo_casediff(0, 5) != -5) {
        printf("FAIL casediff2\n");
        return 1;
    }
    printf("pseudo case arm ok\n");
    return 0;
}
