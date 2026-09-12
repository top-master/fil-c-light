struct foo;
typedef struct foo foo;

struct foo {
    int pad1;
    foo* other;
    int pad2;
    char* string;
    int pad3;
};

void set_foo(foo* node, foo value);
