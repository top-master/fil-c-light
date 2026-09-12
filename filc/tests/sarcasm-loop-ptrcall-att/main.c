#include <stdio.h>

extern long loopret(long);

int main()
{
    long r = loopret(5);
    if (r != 0) { printf("bad loopret %ld\n", r); return 1; }
    printf("loop ptrcall att ok\n");
    return 0;
}
