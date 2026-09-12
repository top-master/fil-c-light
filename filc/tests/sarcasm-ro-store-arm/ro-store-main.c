#include <stdio.h>
void store_ptr(void** p, void* v);
static void* const roslot[1] = { (void*)0 };   // read-only global object
int main(){ int x=1; store_ptr((void**)roslot, &x); printf("SHOULD NOT PRINT (no RO trap)\n"); return 0; }
