#include <stdio.h>

long mul_mem(long x);
long div_mem(long x);

int main()
{
    /* 3 * 12345678901 = 37037036703; 9700 / 97 = 100 */
    if (mul_mem(3) != 37037036703L) {
        printf("FAIL mul_mem: %ld\n", mul_mem(3));
        return 1;
    }
    if (div_mem(9700) != 100) {
        printf("FAIL div_mem: %ld\n", div_mem(9700));
        return 1;
    }
    printf("mulmem ro att ok\n");
    return 0;
}
