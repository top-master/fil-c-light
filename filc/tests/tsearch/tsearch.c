#define _GNU_SOURCE

#include <search.h>
#include <stdfil.h>
#include <stdlib.h>
#include <string.h>

static void whatever(void* arg) { }

int main()
{
    void* root = NULL;
    void* hello = tsearch("hello", &root, (void*)strcmp);
    ZASSERT(hello);
    void* world = tsearch("world", &root, (void*)strcmp);
    ZASSERT(world);
    ZASSERT(tfind("hello", &root, (void*)strcmp) == hello);
    ZASSERT(tfind("world", &root, (void*)strcmp) == world);
    tdestroy(root, whatever);
    return 0;
}

