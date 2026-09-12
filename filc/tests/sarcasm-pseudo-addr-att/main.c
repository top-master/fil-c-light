#include <stdio.h>
#include <stdlib.h>

long pseudo_indexed(unsigned long *base, unsigned long idx);
void pseudo_copy(unsigned long *dst, unsigned long *src);

int main(void)
{
    unsigned long *arr = malloc(4 * sizeof(unsigned long));
    unsigned long *dst = malloc(sizeof(unsigned long));
    if (!arr || !dst)
        return 1;
    arr[0] = 10;
    arr[1] = 20;
    arr[2] = 30;
    arr[3] = 40;
    if (pseudo_indexed(arr, 2) != 30) {
        printf("FAIL indexed\n");
        return 1;
    }
    pseudo_copy(dst, &arr[1]);
    if (*dst != 20) {
        printf("FAIL copy\n");
        return 1;
    }
    printf("pseudo addr ok\n");
    return 0;
}
