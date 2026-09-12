#include <stdlib.h>
#include <stdfil.h>
#include <string.h>
#include <unistd.h>

#define SIZE 2000
#define REPEAT 100
#define LISTSIZE 1000000

struct node {
    struct node* next;
};

static char** one;

static __attribute__((noinline)) void stuff(char** two, struct node* root)
{
    struct node* node = root->next;
    zmemmove(two, one, sizeof(char*) * SIZE);
    free(one);
    zprintf("node = %P\n", node);
}

static __attribute__((noinline)) void do_test(struct node* root)
{
    one = (char**)malloc(sizeof(char*) * SIZE);
    char** two = (char**)malloc(sizeof(char*) * SIZE);

    unsigned i;
    for (i = SIZE; i--;) {
        one[i] = strdup("hello");
        two[i] = strdup("world");
    }

    zgc_wait(zgc_requested_cycle());
    zgc_request_fresh();

    zprintf("one[0] = %s\n", one[0]);

    usleep(1000);

    stuff(two, root);
    zprintf("done\n");
    
    for (i = SIZE; i--;) {
        char* str = two[i];
        if (strcmp(str, "hello")) {
            zprintf("two[%u] = %O, %s\n", i, str, str);
            ZASSERT(!strcmp(str, "hello"));
        }
    }
}

int main()
{
    unsigned i;

    struct node* root = NULL;
    for (i = LISTSIZE; i--;) {
        struct node* node = malloc(sizeof(struct node));
        node->next = root;
        root = node;
    }
    
    for (i = REPEAT; i--;)
        do_test(root);

    zprintf("root = %P\n", root);
    
    return 0;
}

