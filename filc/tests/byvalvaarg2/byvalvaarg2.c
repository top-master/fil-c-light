#include <stdarg.h>
#include <stdfil.h>

typedef struct {
    int i;
    int j;
} S;

int fn(int cnt, ...)
{
    va_list ap;
    va_start(ap, cnt);
    S s = va_arg(ap, S);
    va_end(ap);
    return s.i + s.j;
}

int main()
{
    S s;
    s.i = 666;
    s.j = 1410;
    ZASSERT(fn(42, s) == 666 + 1410);
    return 0;
}

