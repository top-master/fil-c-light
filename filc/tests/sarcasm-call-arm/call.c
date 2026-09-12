#include <stdio.h>
#include <stdlib.h>

int foo(int** array, size_t index);

int main()
{
    int x = 67;
    int* array[100];
    array[42] = &x;
    printf("%d\n", foo(array, 42));
    return 0;
}
