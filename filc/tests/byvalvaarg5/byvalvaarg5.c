#include <stdarg.h>
#include <stdfil.h>

typedef struct {
    int i;
    int j;
    int k;
    int l;
    int m;
} S;

int fn(int cnt, ...)
{
    va_list ap;
    va_start(ap, cnt);
    S s = va_arg(ap, S);
    va_end(ap);
    return s.i + s.j + s.k + s.l + s.m;
}

int main()
{
    S s;
    s.i = 666;
    s.j = 1410;
    s.k = 9000;
    s.l = 11;
    s.m = 5150;
    ZASSERT(fn(42, s) == 666 + 1410 + 9000 + 11 + 5150);
    return 0;
}

