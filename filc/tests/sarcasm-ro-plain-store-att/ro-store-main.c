#include <stdio.h>
void store_long(void* p, long v);
static const long rocell[1] = { 0 };   // read-only global object
int main(){ store_long((void*)rocell, 5); printf("SHOULD NOT PRINT (no RO trap)\n"); return 0; }
