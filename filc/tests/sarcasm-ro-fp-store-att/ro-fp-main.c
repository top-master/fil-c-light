#include <stdio.h>
void store_double(void* p, long bits);
static const double rocell[1] = { 0 };   // read-only global object
int main(){ store_double((void*)rocell, 0x3ff8000000000000L); printf("SHOULD NOT PRINT (no RO trap)\n"); return 0; }
