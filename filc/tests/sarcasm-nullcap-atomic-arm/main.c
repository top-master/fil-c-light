#include <stdio.h>
void f(void* p, long v);
int main()
{
    printf("expect trap:\n");
    fflush(stdout);
    /* integer address 0x12345: null capability. */
    f((void*)0x12345, 1);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
