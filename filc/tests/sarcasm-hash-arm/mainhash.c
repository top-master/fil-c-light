#include <stdio.h>
unsigned long hash(unsigned char *str);
int main() {
    printf("%lu\n", hash((unsigned char*)"hello"));
    printf("%lu\n", hash((unsigned char*)""));
    return 0;
}
