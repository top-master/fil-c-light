#include <stdio.h>

long f_redzone(long a);
long g_redzone(long a);

int main()
{
    printf("redzone %ld %ld\n", f_redzone(21), g_redzone(50));
    return 0;
}
