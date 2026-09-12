#include <stdlib.h>
#include <stdfil.h>
#include <string.h>
#include <unistd.h>

#define SIZE 2000
#define REPEAT 100
#define LISTSIZE 1000000

struct node {
    struct node* next;
    void* value;
};

struct node* root;

static __attribute__((noinline)) void do_test(void)
{
    char** one = (char**)malloc(sizeof(char*) * SIZE);
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

    root->value = two;
    zmemmove(two, one, sizeof(char*) * SIZE);
    free(one);

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

    for (i = LISTSIZE; i--;) {
        struct node* node = malloc(sizeof(struct node));
        node->next = root;
        root = node;
    }
    
    for (i = REPEAT; i--;)
        do_test();
    
    return 0;
}

