#include <stdio.h>
void bump(void* p, long v);
static const long rocell[1] = { 0 };   // read-only global object
int main(){ bump((void*)rocell, 5); printf("SHOULD NOT PRINT (no RO trap)\n"); return 0; }
