#include <stdlib.h>
#include <stdfil.h>
#include <string.h>
#include <unistd.h>

#define SIZE 4000
#define REPEAT 100
#define LISTSIZE 100000

struct node {
    struct node* next;
};

static char** global;

static __attribute__((noinline)) void do_test(struct node* root)
{
    char** array =(char**)malloc(sizeof(char*) * SIZE);
    global = array;

    unsigned i;
    for (i = SIZE; i--;)
        array[i] = zasprintf("i = %d", i);

    zgc_wait(zgc_requested_cycle());
    zgc_request_fresh();

    zprintf("array[0] = %s\n", array[0]);

    usleep(1000);

    zmemmove(array, array + SIZE / 2, sizeof(char*) * SIZE / 2);
    zmemset(array + SIZE / 2, 0, sizeof(char*) * SIZE / 2);
    zprintf("done\n");
    
    for (i = SIZE / 2; i--;) {
        char* str = array[i];
        char* expected = zasprintf("i = %d", i + SIZE / 2);
        if (strcmp(str, expected)) {
            zprintf("array[%u] = %O, %s\n", i, str, str);
            zprintf("expected = %s\n", expected);
            ZASSERT(!strcmp(str, expected));
        }
    }
    for (i = SIZE; i-->SIZE;) {
        char* str = array[i];
        if (str) {
            zprintf("array[%u] = %O, %s\n", i, str, str);
            ZASSERT(!str);
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

