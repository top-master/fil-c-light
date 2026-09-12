#include <stdio.h>

long leaidx_oob(long i);

int main(void)
{
    printf("expect trap:\n");
    printf("%ld SHOULD NOT PRINT\n", leaidx_oob(100));
    return 0;
}
