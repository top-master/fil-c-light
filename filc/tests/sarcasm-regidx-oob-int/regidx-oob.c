#include <stdio.h>
#include <stdlib.h>
#include <string.h>
unsigned long get(unsigned char* b, unsigned long i);
int main() {
    unsigned char* b = malloc(4); memset(b,'A',4);
    printf("expect trap:\n");
    printf("%lu SHOULD NOT PRINT\n", get(b, 1000000));  // OOB index -> trap
    return 0;
}
