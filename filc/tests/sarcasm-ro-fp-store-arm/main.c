#include <stdio.h>
void f(void* p, long lo, long hi);
static const double rocell[2] = { 0 };   /* read-only global object */
int main()
{
    printf("expect trap:\n");
    fflush(stdout);
    f((void*)rocell, 0, 0);
    printf("SHOULD NOT PRINT (no RO trap)\n");
    return 0;
}
