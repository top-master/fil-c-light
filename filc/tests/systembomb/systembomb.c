#include <stdlib.h>
#include <stdfil.h>
#include <stdio.h>
#include <string.h>
#include <filc_test_support.h>
#include <unistd.h>

static size_t num_nodes = 40000;

struct foo;
typedef struct foo foo;

struct foo {
    foo* other;
    char* string;
};

static foo* root;

static void add_node(void)
{
    foo* node = (foo*)malloc(sizeof(foo));
    node->other = root;
    asprintf(&node->string, "node = %p", node);
    root = node;
}

static void build(void)
{
    size_t index;
    for (index = num_nodes; index--;)
        add_node();
}

static void remove_half(void)
{
    foo** ptr;
    size_t index;
    for (ptr = &root, index = 0; *ptr; index++) {
        if ((index & 1))
            ptr = &(*ptr)->other;
        else
            *ptr = (*ptr)->other;
    }
}

static void add_half(void)
{
    size_t index;
    for (index = num_nodes / 2; index--;)
        add_node();
}

static void verify(void)
{
    foo* node;
    for (node = root; node; node = node->other) {
        char* str;
        asprintf(&str, "node = %p", node);
        ZASSERT(!strcmp(node->string, str));
    }
}

int main()
{
    build();
    unsigned n;
    for (n = 100; n--;) {
        remove_half();
        ZASSERT(!system("echo hello"));
        add_half();
    }
    verify();
    return 0;
}
