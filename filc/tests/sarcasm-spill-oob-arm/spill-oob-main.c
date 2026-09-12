#include <stdio.h>
#include <stdlib.h>
unsigned long sumn(unsigned long* p);
int main() {
    unsigned long* p = malloc(1 * sizeof(unsigned long));  // only 1 word; sumn reads 26
    printf("%lu\n", sumn(p));                               // must trap on the 2nd load
    return 0;
}
