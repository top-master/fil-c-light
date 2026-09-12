#include <stdio.h>
void f(void** p, void* v);
static void* const roslot[1] = { (void*)0 };   // read-only global object
int main(){ int x=1; f((void**)roslot, &x); printf("SHOULD NOT PRINT (no RO trap)\n"); return 0; }
