/* Intel-syntax twin of sarcasm-global-rodata-att. */
#include <stdio.h>
long roread(void);
long roread2(long unused);
int main()
{
    if (roread() != 100) {
        printf("FAIL roread\n");
        return 1;
    }
    if (roread2(0) != 52) {
        printf("FAIL roread2\n");
        return 1;
    }
    printf("rodata int ok\n");
    return 0;
}
