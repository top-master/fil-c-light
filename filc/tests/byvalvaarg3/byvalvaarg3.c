#include <stdarg.h>
#include <stdfil.h>

typedef struct {
    int i;
    int j;
    int k;
} S;

int fn(int cnt, ...)
{
    va_list ap;
    va_start(ap, cnt);
    S s = va_arg(ap, S);
    va_end(ap);
    return s.i + s.j + s.k;
}

int main()
{
    S s;
    s.i = 666;
    s.j = 1410;
    s.k = 9000;
    ZASSERT(fn(42, s) == 666 + 1410 + 9000);
    return 0;
}

