#include <stdio.h>

long f_alias(long bits);
long g_alias(long bits);

#define BITS_1 0x3FF0000000000000L  /* 1.0 */
#define BITS_4 0x4010000000000000L  /* 4.0 */

int main()
{
    printf("alias %ld %ld\n", f_alias(BITS_1), g_alias(BITS_4));
    return 0;
}
