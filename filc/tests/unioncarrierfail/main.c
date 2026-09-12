#include "value.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdfil.h>

int main(void)
{
    int *p = malloc(16);
    union Hidden value = { .pointers = { p + 4 } };
    value = bounce(value);
    // Losing the capability would give a null-object error; bypassing bounds
    // would allow this read. A preserved one-past capability must trap at upper.
    printf("%d\n", *value.pointers[0]);
    zprint("nono\n");
    return 0;
}
