#include <stdio.h>
#include <stdlib.h>

int foo(int** array, size_t index);

int main()
{
    int x = 67;
    int* array[100];
    array[42] = &x + 100; /* This causes OOB in the
                             assembly code. */
    printf("%d\n", foo(array, 42));
    return 0;
}
