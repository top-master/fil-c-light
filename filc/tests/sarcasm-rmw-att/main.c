#include <stdio.h>

long f(long* a, long* b);

int main()
{
    /* f returns s.v + y + *s.p = 10 + 20 + 12 = 42. */
    struct { long v; long* p; } s = { 10, 0 };
    long y = 20, z = 12;
    s.p = &z;
    printf("%ld\n", f((long*)&s, &y));
    return 0;
}
