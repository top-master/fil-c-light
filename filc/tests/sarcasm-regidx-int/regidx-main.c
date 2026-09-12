#include <stdio.h>
unsigned long get(unsigned char* b, unsigned long i);
int main() {
    unsigned char* s = (unsigned char*)"hello";
    printf("%lu %lu %lu\n", get(s,0), get(s,1), get(s,4));  // 104 101 111
    return 0;
}
