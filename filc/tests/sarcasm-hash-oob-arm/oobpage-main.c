#include <stdio.h>
#include <stdlib.h>
#include <string.h>
unsigned long hash(unsigned char *str);
int main() {
    size_t n = 4096;
    unsigned char *buf = malloc(n);
    memset(buf, 'A', n);                 // exact allocation, no NUL: hash must trap at buf[n]
    printf("hashing page OOB\n");
    printf("%lu (SHOULD NOT PRINT)\n", hash(buf));
    return 0;
}
