#include <stdarg.h>
#include <stdfil.h>

typedef struct {
    int i;
} S;

int fn(int cnt, ...)
{
    va_list ap;
    va_start(ap, cnt);
    S s = va_arg(ap, S);
    va_end(ap);
    return s.i;
}

int main()
{
    S s;
    s.i = 666;
    ZASSERT(fn(42, s) == 666);
    return 0;
}

