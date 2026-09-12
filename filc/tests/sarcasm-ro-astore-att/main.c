#include <stdio.h>
void ap_store(void** p, void* v);
static void* const roslot[1] = { (void*)0 };   // read-only global object
int main(){ int x=1; ap_store((void**)roslot, &x); printf("SHOULD NOT PRINT (no RO trap)\n"); return 0; }
