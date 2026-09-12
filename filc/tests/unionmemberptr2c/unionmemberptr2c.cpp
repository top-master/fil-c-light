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

class NonzeroC {
public:
    Nonzero f;
};

class NonzeroCS : public NonzeroC {
public:
    int x;
};

class Nonzero2C {
public:
    Nonzero2 f;
};

class Nonzero2CS : public Nonzero2C {
public:
    int x;
};

class Nonzero2bC {
public:
    Nonzero2b f;
};

class Nonzero2bCS : public Nonzero2bC {
public:
    int x;
};

class Nonzero3C {
public:
    Nonzero3 f;
};

class Nonzero3CS : public Nonzero3C {
public:
    int x;
};

class Nonzero3bC {
public:
    Nonzero3b f;
};

class Nonzero3bCS : public Nonzero3bC {
public:
    int x;
};

class Nonzero3cC {
public:
    Nonzero3c f;
};

class Nonzero3cCS : public Nonzero3cC {
public:
    int x;
};

class Nonzero4C {
public:
    Nonzero4 f;
};

class Nonzero4CS : public Nonzero4C {
public:
    int x;
};

static NonzeroCS nz;
static Nonzero2CS nz2;
static Nonzero2bCS nz2b;
static Nonzero3CS nz3;
static Nonzero3bCS nz3b;
static Nonzero3cCS nz3c;
static Nonzero4CS nz4;

int main()
{
    ZASSERT(nz.f.pointer == (int*)-1);
    ZASSERT(nz2.f.pointer == (int*)-1);
    ZASSERT(nz2.f.pointer2 == (int*)-1);
    ZASSERT(nz2b.f.s2.pointer == (int*)-1);
    ZASSERT(nz2b.f.s2.pointer2 == (int*)-1);
    ZASSERT(nz3.f.pointer == (int*)-1);
    ZASSERT(nz3.f.pointer2 == (int*)-1);
    ZASSERT(nz3.f.pointer3 == (int*)-1);
    ZASSERT(nz3.f.pointer4 == (int*)-1);
    ZASSERT(nz3.f.pointer5 == (int*)-1);
    ZASSERT(nz3b.f.s2.pointer == (int*)-1);
    ZASSERT(nz3b.f.s2.pointer2 == (int*)-1);
    ZASSERT(nz3b.f.s2.pointer3 == (int*)-1);
    ZASSERT(nz3b.f.s2.pointer4 == (int*)-1);
    ZASSERT(nz3b.f.s2.pointer5 == (int*)-1);
    ZASSERT(!nz3c.f.s2.pointer);
    ZASSERT(nz3c.f.s2.pointer2 == (int*)-1);
    ZASSERT(!nz3c.f.s2.pointer3);
    ZASSERT(nz3c.f.s2.pointer4 == (int*)-1);
    ZASSERT(!nz3c.f.s2.pointer5);
    ZASSERT(!nz4.f.s2.pointer);
    ZASSERT(!nz4.f.s2.pointer2);
    ZASSERT(!nz4.f.s2.pointer3);
    ZASSERT(!nz4.f.s2.pointer4);
    ZASSERT(!nz4.f.s2.pointer5);
    return 0;
}
