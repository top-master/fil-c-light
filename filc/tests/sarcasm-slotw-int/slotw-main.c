#include <stdio.h>
unsigned loww(unsigned long x);
int main(){ printf("%u\n", loww(0x12345678UL)); return 0; }   /* low 16 bits = 0x5678 = 22136 */
