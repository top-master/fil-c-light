#include <stdio.h>
#include <stdlib.h>
#include <string.h>

long x87_mem(void* buf);
long x87_stack(long n);

int main()
{
    double* buf = malloc(48);
    if (!buf)
        return 1;
    buf[0] = 1.5;
    buf[1] = 2.25;
    buf[2] = 0.0;
    ((int*)buf)[6] = 42;   /* buf+24 */
    buf[4] = 0.0;          /* buf+32: fistpq result */
    long r = x87_mem(buf);
    if (buf[2] != 3.75)
        return 1;
    if (r != 42)
        return 1;
    long s = x87_stack(41);
    if (s != 84)
        return 1;
    printf("x87 ok\n");
    return 0;
}
