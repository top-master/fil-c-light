#include <stdarg.h>
#include <stdfil.h>

typedef struct {
    int i;
    int j;
    int k;
    int l;
} S;

int fn(int cnt, ...)
{
    va_list ap;
    va_start(ap, cnt);
    S s = va_arg(ap, S);
    va_end(ap);
    return s.i + s.j + s.k + s.l;
}

int main()
{
    S s;
    s.i = 666;
    s.j = 1410;
    s.k = 9000;
    s.l = 11;
    ZASSERT(fn(42, s) == 666 + 1410 + 9000 + 11);
    return 0;
}

