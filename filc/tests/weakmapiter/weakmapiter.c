#include <stdfil.h>
#include <string.h>
#include "utils.h"
#include <stdbool.h>

static __attribute__((noinline)) void test1(zweak_map* map)
{
    char* hello3 = strdup("hello3");
    zweak_map_set(map, hello3, "world3");
    ZASSERT(!strcmp(zweak_map_get(map, hello3), "world3"));
    char* hello4 = strdup("hello4");
    zweak_map_set(map, hello4, strdup("world4"));
    ZASSERT(!strcmp(zweak_map_get(map, hello4), "world4"));
    char* hello5 = strdup("hello5");
    zweak_map_set(map, hello5, strdup("world5"));
    ZASSERT(!strcmp(zweak_map_get(map, hello5), "world5"));
    ZASSERT(zweak_map_size(map) == 7);
    zweak_map_set(map, hello5, NULL);
    ZASSERT(zweak_map_size(map) == 6);
    ZASSERT(!zweak_map_get(map, hello5));

    zweak_map_iter* iter = zweak_map_get_iter(map);
    bool saw_hello = false;
    bool saw_hello2 = false;
    bool saw_666 = false;
    bool saw_null = false;
    bool saw_hello3 = false;
    bool saw_hello4 = false;
    while (zweak_map_iter_next(iter)) {
        if (!zweak_map_iter_key(iter)) {
            ZASSERT(!saw_null);
            ZASSERT(!zgetlower(zweak_map_iter_key(iter)));
            ZASSERT(!strcmp(zweak_map_iter_value(iter), "winners don't make excuses"));
            saw_null = true;
            continue;
        }
        if (zweak_map_iter_key(iter) == (void*)666) {
            ZASSERT(!saw_666);
            ZASSERT(!zgetlower(zweak_map_iter_key(iter)));
            ZASSERT(zweak_map_iter_value(iter) == (void*)1410);
            ZASSERT(!zgetlower(zweak_map_iter_value(iter)));
            saw_666 = true;
            continue;
        }
        if (!strcmp(zweak_map_iter_key(iter), "hello")) {
            ZASSERT(!saw_hello);
            ZASSERT(!strcmp(zweak_map_iter_value(iter), "world"));
            saw_hello = true;
            continue;
        }
        if (!strcmp(zweak_map_iter_key(iter), "hello2")) {
            ZASSERT(!saw_hello2);
            ZASSERT(!strcmp(zweak_map_iter_value(iter), "world2"));
            saw_hello2 = true;
            continue;
        }
        if (!strcmp(zweak_map_iter_key(iter), "hello3")) {
            ZASSERT(!saw_hello3);
            ZASSERT(!strcmp(zweak_map_iter_value(iter), "world3"));
            saw_hello3 = true;
            continue;
        }
        if (!strcmp(zweak_map_iter_key(iter), "hello4")) {
            ZASSERT(!saw_hello4);
            ZASSERT(!strcmp(zweak_map_iter_value(iter), "world4"));
            saw_hello4 = true;
            continue;
        }
        zprintf("Unexpected key: %O\n", zweak_map_iter_key(iter));
        ZASSERT(!"Should not get here");
    }
    ZASSERT(saw_hello);
    ZASSERT(saw_hello2);
    ZASSERT(saw_null);
    ZASSERT(saw_666);
    ZASSERT(saw_hello3);
    ZASSERT(saw_hello4);
    
    opaque(hello3);
    opaque(hello4);
}

static __attribute__((noinline)) void doit(void)
{
    zweak_map* map = zweak_map_new();
    zweak_map_set(map, "hello", "world");
    ZASSERT(!strcmp(zweak_map_get(map, "hello"), "world"));
    zweak_map_set(map, "hello2", strdup("world2"));
    ZASSERT(!strcmp(zweak_map_get(map, "hello2"), "world2"));
    zweak_map_set(map, (void*)666, (void*)1410);
    ZASSERT(zweak_map_get(map, (void*)666) == (void*)1410);
    zweak_map_set(map, NULL, strdup("winners don't make excuses"));
    ZASSERT(!strcmp(zweak_map_get(map, NULL), "winners don't make excuses"));
    test1(map);
    zgc_request_and_wait();
    ZASSERT(zweak_map_size(map) == 4);

    zweak_map_iter* iter = zweak_map_get_iter(map);
    bool saw_hello = false;
    bool saw_hello2 = false;
    bool saw_666 = false;
    bool saw_null = false;
    while (zweak_map_iter_next(iter)) {
        if (!zweak_map_iter_key(iter)) {
            ZASSERT(!saw_null);
            ZASSERT(!zgetlower(zweak_map_iter_key(iter)));
            ZASSERT(!strcmp(zweak_map_iter_value(iter), "winners don't make excuses"));
            saw_null = true;
            continue;
        }
        if (zweak_map_iter_key(iter) == (void*)666) {
            ZASSERT(!saw_666);
            ZASSERT(!zgetlower(zweak_map_iter_key(iter)));
            ZASSERT(zweak_map_iter_value(iter) == (void*)1410);
            ZASSERT(!zgetlower(zweak_map_iter_value(iter)));
            saw_666 = true;
            continue;
        }
        if (!strcmp(zweak_map_iter_key(iter), "hello")) {
            ZASSERT(!saw_hello);
            ZASSERT(!strcmp(zweak_map_iter_value(iter), "world"));
            saw_hello = true;
            continue;
        }
        if (!strcmp(zweak_map_iter_key(iter), "hello2")) {
            ZASSERT(!saw_hello2);
            ZASSERT(!strcmp(zweak_map_iter_value(iter), "world2"));
            saw_hello2 = true;
            continue;
        }
        zprintf("Unexpected key: %O\n", zweak_map_iter_key(iter));
        ZASSERT(!"Should not get here");
    }
    ZASSERT(saw_hello);
    ZASSERT(saw_hello2);
    ZASSERT(saw_null);
    ZASSERT(saw_666);

    ZASSERT(!strcmp(zweak_map_get(map, "hello"), "world"));
    ZASSERT(!strcmp(zweak_map_get(map, "hello2"), "world2"));
    ZASSERT(!strcmp(zweak_map_get(map, NULL), "winners don't make excuses"));
    ZASSERT(zweak_map_get(map, (void*)666) == (void*)1410);
    zweak_map_set(map, "hello", NULL);
    ZASSERT(zweak_map_size(map) == 3);
    ZASSERT(!zweak_map_get(map, "hello"));
}

int main()
{
    unsigned count;
    for (count = 10000; count--;)
        doit();
    return 0;
}

