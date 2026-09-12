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
    Nonzero nzArray[4]{};
    Nonzero2 nz2Array[4]{};
    Nonzero2b nz2bArray[4]{};
    Nonzero3 nz3Array[4]{};
    Nonzero3b nz3bArray[4]{};
    Nonzero3c nz3cArray[4]{};
    Nonzero4 nz4Array[4]{};
    
    for (unsigned i = 4; i--;) {
        Nonzero& nz = nzArray[i];
        Nonzero2& nz2 = nz2Array[i];
        Nonzero2b& nz2b = nz2bArray[i];
        Nonzero3& nz3 = nz3Array[i];
        Nonzero3b& nz3b = nz3bArray[i];
        Nonzero3c& nz3c = nz3cArray[i];
        Nonzero4& nz4 = nz4Array[i];
        
        ZASSERT(nz.pointer == (int*)-1);
        ZASSERT(nz2.pointer == (int*)-1);
        ZASSERT(nz2.pointer2 == (int*)-1);
        ZASSERT(nz2b.s2.pointer == (int*)-1);
        ZASSERT(nz2b.s2.pointer2 == (int*)-1);
        ZASSERT(nz3.pointer == (int*)-1);
        ZASSERT(nz3.pointer2 == (int*)-1);
        ZASSERT(nz3.pointer3 == (int*)-1);
        ZASSERT(nz3.pointer4 == (int*)-1);
        ZASSERT(nz3.pointer5 == (int*)-1);
        ZASSERT(nz3b.s2.pointer == (int*)-1);
        ZASSERT(nz3b.s2.pointer2 == (int*)-1);
        ZASSERT(nz3b.s2.pointer3 == (int*)-1);
        ZASSERT(nz3b.s2.pointer4 == (int*)-1);
        ZASSERT(nz3b.s2.pointer5 == (int*)-1);
        ZASSERT(!nz3c.s2.pointer);
        ZASSERT(nz3c.s2.pointer2 == (int*)-1);
        ZASSERT(!nz3c.s2.pointer3);
        ZASSERT(nz3c.s2.pointer4 == (int*)-1);
        ZASSERT(!nz3c.s2.pointer5);
        ZASSERT(!nz4.s2.pointer);
        ZASSERT(!nz4.s2.pointer2);
        ZASSERT(!nz4.s2.pointer3);
        ZASSERT(!nz4.s2.pointer4);
        ZASSERT(!nz4.s2.pointer5);
    }
    
    return 0;
}
