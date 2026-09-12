#include <stdio.h>
#include <stdfil.h>

extern long calladd7(void);

long add7(long x)
{
    return x + 7;
}

int main()
{
    long result = calladd7();
    ZASSERT(result == 7);
    printf("%ld\n", result);
    return 0;
}
