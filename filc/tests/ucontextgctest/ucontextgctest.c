#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdfil.h>
#include <filc_test_support.h>
#include <ucontext.h>
#include <stdbool.h>

#define ASSERT(exp) do { \
    if ((exp)) \
        break; \
    fprintf(stderr, "%s:%d: %s: assertion %s failed.\n", \
            __FILE__, __LINE__, __PRETTY_FUNCTION__, #exp); \
    abort(); \
} while (0)

static size_t num_nodes = 4000;
static size_t repeat = 10;
static size_t num_contexts = 10;

struct foo;
typedef struct foo foo;

struct foo {
    foo* other;
    char* string;
};

struct context {
    ucontext_t context;
    bool done;
};

static ucontext_t main_context;
static struct context* contexts;
static size_t context_index;

static void definitely_switch(void)
{
    size_t was_in_context = context_index;

    size_t index;
    for (index = (context_index + 1) % num_contexts;
         index != context_index;
         index = (index + 1) % num_contexts) {
        if (!contexts[index].done) {
            context_index = index;
            swapcontext(&contexts[was_in_context].context, &contexts[context_index].context);
            ZASSERT(context_index == was_in_context);
            return;
        }
    }

    if (!contexts[context_index].done)
        return;

    setcontext(&main_context);
    ZASSERT("!Should not be reached");
}

static size_t counter;

static void maybe_switch(void)
{
    counter++;
    if (counter == 67) {
        counter = 0;
        definitely_switch();
    }
}

static void* maybe_switch_identity(void* x)
{
    maybe_switch();
    return x;
}

static void add_node(struct foo** root)
{
    foo* node = (foo*)malloc(sizeof(foo));
    node->other = *root;
    maybe_switch();
    asprintf(&node->string, "node = %p", node);
    *root = node;
}

static void build(struct foo** root)
{
    size_t index;
    for (index = num_nodes; index--;)
        add_node(root);
}

static void remove_half(struct foo** root)
{
    foo** ptr;
    size_t index;
    for (ptr = root, index = 0; *ptr; index++) {
        if ((index & 1))
            ptr = maybe_switch_identity(&(*ptr)->other);
        else
            *ptr = maybe_switch_identity((*ptr)->other);
    }
}

static void add_half(struct foo** root)
{
    size_t index;
    for (index = num_nodes / 2; index--;)
        add_node(root);
}

static void verify(struct foo** root)
{
    foo* node;
    for (node = *root; node; node = node->other) {
        char* str;
        asprintf(&str, "node = %p", node);
        maybe_switch();
        ASSERT(!strcmp(node->string, str));
    }
}

static void run(void)
{
    struct foo* root;

    build(&root);
    verify(&root);
    size_t index;
    for (index = 1; index <= repeat; ++index) {
        printf("Iteration %zu\n", index);
        remove_half(&root);
        verify(&root);
        add_half(&root);
        verify(&root);
    }

    zprintf("context %zu done\n", context_index);
    contexts[context_index].done = true;
    definitely_switch();
    ZASSERT(!"Should not be reached");
}

int main()
{
    if (!zgc_is_stw()) {
        num_nodes *= 2;
        repeat *= 2;
    }

    contexts = (struct context*)malloc(sizeof(struct context) * num_contexts);
    size_t index;
    for (index = num_contexts; index--;) {
        getcontext(&contexts[index].context);
        contexts[index].context.uc_stack.ss_size = 16384;
        contexts[index].context.uc_link = NULL;
        makecontext(&contexts[index].context, run, 0);
    }

    context_index = 0;
    swapcontext(&main_context, &contexts[context_index].context);

    for (index = num_contexts; index--;)
        ZASSERT(contexts[index].done);
    
    printf("Success!\n");
    return 0;
}

