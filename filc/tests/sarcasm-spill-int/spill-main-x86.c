#include <stdio.h>
#include <stdlib.h>
unsigned long sumn(unsigned long *a);
int main() {
    unsigned long *a = malloc(13*sizeof(unsigned long));
    for (int i=0;i<13;i++) a[i]=i+1;
    printf("%lu\n", sumn(a));   // 1+..+13 = 91
    return 0;
}
