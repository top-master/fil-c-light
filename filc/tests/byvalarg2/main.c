#include <stdfil.h>
#include "struct.h"

char foo(struct foo x, struct foo y);

int main()
{
    struct foo x;
    struct foo y;
    x.a = 1;
    x.b = 2;
    x.c = 3;
    x.d = 4;
    x.e = 5;
    x.f = 6;
    x.g = 7;
    x.h = 8;
    x.i = 9;
    x.j = 10;
    x.k = 11;
    x.l = 12;
    x.m = 13;
    x.n = 14;
    x.o = 15;
    x.p = 16;
    x.q = 17;
    x.r = 18;
    x.s = 19;
    y.a = 20;
    y.b = 21;
    y.c = 22;
    y.d = 23;
    y.e = 24;
    y.f = 25;
    y.g = 26;
    y.h = 27;
    y.i = 28;
    y.j = 29;
    y.k = 30;
    y.l = 31;
    y.m = 32;
    y.n = 33;
    y.o = 34;
    y.p = 35;
    y.q = 36;
    y.r = 37;
    y.s = 28;
    ZASSERT(foo(x, y) == 21);
    return 0;
}

