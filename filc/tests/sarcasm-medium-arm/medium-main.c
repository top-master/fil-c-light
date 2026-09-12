#include <stdio.h>
unsigned long medium(unsigned long *a, unsigned char *b);
int main(){unsigned long a[64];unsigned char b[128];for(int i=0;i<64;i++)a[i]=i*2654435761u+1;for(int i=0;i<128;i++)b[i]=(unsigned char)(i*37+11);printf("%lu\n",medium(a,b));return 0;}
