#include <stdio.h>

long pseudo_casediff(long a, long b);
long pseudo_casekill(long a);

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
    if (pseudo_casekill(5) != 12) {
        printf("FAIL casekill\n");
        return 1;
    }
    printf("pseudo case ok\n");
    return 0;
}
