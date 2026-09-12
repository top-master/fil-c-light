#include <stdio.h>
#include <stdlib.h>

long fpsum(double* a, long n);

int main()
{
    long n = 100000;
    double* a = malloc(n * sizeof(double));
    if (!a)
        return 1;
    long i;
    for (i = 0; i < n; i++)
        a[i] = 1.5;
    printf("loop %ld\n", fpsum(a, n));
    return 0;
}
