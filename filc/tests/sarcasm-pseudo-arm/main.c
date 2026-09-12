#include <stdio.h>
#include <stdlib.h>

long pseudo_sum(long a, long b, long c);
long pseudo_ptr(unsigned long *base, unsigned long idx);

int main(void)
{
    if (pseudo_sum(1, 2, 3) != 6) {
        printf("FAIL sum\n");
        return 1;
    }
    unsigned long *arr = malloc(4 * sizeof(unsigned long));
    if (!arr)
        return 1;
    arr[0] = 10;
    arr[1] = 20;
    arr[2] = 30;
    arr[3] = 40;
    if (pseudo_ptr(arr, 2) != 30) {
        printf("FAIL ptr\n");
        return 1;
    }
    printf("pseudo arm ok\n");
    return 0;
}
