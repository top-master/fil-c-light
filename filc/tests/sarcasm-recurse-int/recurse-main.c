#include <stdio.h>
void recurse(void* p);
int main(){ int x; recurse(&x); printf("SHOULD NOT PRINT (no stack overflow)\n"); return 0; }
