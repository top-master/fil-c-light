#include <stdfil.h>

struct C { int value; };

union Nonzero { int C::*member; int *pointer; };

union Nonzero2 {
    struct {
        int C::*member;
        int C::*member2;
    } s;
    int *pointer;
    int *pointer2;
};

union Nonzero2b {
    struct {
        int C::*member;
        int C::*member2;
    } s;
    struct {
        int *pointer;
        int *pointer2;
    } s2;
};

union Nonzero3 {
    struct {
        int C::*member;
        int C::*member2;
        int C::*member3;
        int C::*member4;
        int C::*member5;
    } s;
    int *pointer;
    int *pointer2;
    int *pointer3;
    int *pointer4;
    int *pointer5;
};

union Nonzero3b {
    struct {
        int C::*member;
        int C::*member2;
        int C::*member3;
        int C::*member4;
        int C::*member5;
    } s;
    struct {
        int *pointer;
        int *pointer2;
        int *pointer3;
        int *pointer4;
        int *pointer5;
    } s2;
};

union Nonzero3c {
    struct {
        int a;
        int b;
        int C::*member2;
        int c;
        int d;
        int C::*member4;
    } s;
    struct {
        int *pointer;
        int *pointer2;
        int *pointer3;
        int *pointer4;
        int *pointer5;
    } s2;
};

union Nonzero4 {
    struct {
        int *pointer;
        int *pointer2;
        int *pointer3;
        int *pointer4;
        int *pointer5;
    } s2;
    struct {
        int C::*member;
        int C::*member2;
        int C::*member3;
        int C::*member4;
        int C::*member5;
    } s;
};

int main()
{
    Nonzero nz{};
    ZASSERT(nz.pointer == (int*)-1);
    Nonzero2 nz2{};
    ZASSERT(nz2.pointer == (int*)-1);
    ZASSERT(nz2.pointer2 == (int*)-1);
    Nonzero2b nz2b{};
    ZASSERT(nz2b.s2.pointer == (int*)-1);
    ZASSERT(nz2b.s2.pointer2 == (int*)-1);
    Nonzero3 nz3{};
    ZASSERT(nz3.pointer == (int*)-1);
    ZASSERT(nz3.pointer2 == (int*)-1);
    ZASSERT(nz3.pointer3 == (int*)-1);
    ZASSERT(nz3.pointer4 == (int*)-1);
    ZASSERT(nz3.pointer5 == (int*)-1);
    Nonzero3b nz3b{};
    ZASSERT(nz3b.s2.pointer == (int*)-1);
    ZASSERT(nz3b.s2.pointer2 == (int*)-1);
    ZASSERT(nz3b.s2.pointer3 == (int*)-1);
    ZASSERT(nz3b.s2.pointer4 == (int*)-1);
    ZASSERT(nz3b.s2.pointer5 == (int*)-1);
    Nonzero3c nz3c{};
    ZASSERT(!nz3c.s2.pointer);
    ZASSERT(nz3c.s2.pointer2 == (int*)-1);
    ZASSERT(!nz3c.s2.pointer3);
    ZASSERT(nz3c.s2.pointer4 == (int*)-1);
    ZASSERT(!nz3c.s2.pointer5);
    Nonzero4 nz4{};
    ZASSERT(!nz4.s2.pointer);
    ZASSERT(!nz4.s2.pointer2);
    ZASSERT(!nz4.s2.pointer3);
    ZASSERT(!nz4.s2.pointer4);
    ZASSERT(!nz4.s2.pointer5);
    return 0;
}
