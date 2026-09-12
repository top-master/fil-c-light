#include <stdio.h>
unsigned getb(unsigned char* b, unsigned long i);
int main(){ printf("%u\n", getb((unsigned char*)"hello", 1)); return 0; }  /* 'e' = 101 */
