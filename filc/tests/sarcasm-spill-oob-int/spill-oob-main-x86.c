#include <stdio.h>
#include <stdlib.h>
unsigned long sumn(unsigned long *a);   // reads a[0..12]
int main() {
    unsigned long *a = malloc(2 * sizeof(unsigned long));  // too small -> a[2..12] OOB
    a[0] = 1; a[1] = 2;
    printf("expect trap:\n");
    printf("%lu SHOULD NOT PRINT\n", sumn(a));
    return 0;
}
