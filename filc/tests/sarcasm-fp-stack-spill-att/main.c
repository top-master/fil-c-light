#include <stdio.h>

long f_spill(long a, long b);

int main()
{
    printf("spill %ld %ld\n", f_spill(3, 4), f_spill(10, 20));
    return 0;
}
