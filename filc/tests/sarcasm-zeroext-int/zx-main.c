#include <stdio.h>
unsigned long zx(unsigned long *a);
int main(){ unsigned long a[1]={0xDEADBEEFCAFEUL}; printf("%lu\n", zx(a)); return 0; }  /* low32(a[0]<<40)=0 */
