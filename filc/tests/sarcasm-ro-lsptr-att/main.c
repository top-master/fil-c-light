#include <stdio.h>
void f(void** p, long d);
static void* const roslot[1] = { (void*)0 };   // read-only global object
int main(){ f((void**)roslot, 8); printf("SHOULD NOT PRINT (no RO trap)\n"); return 0; }
