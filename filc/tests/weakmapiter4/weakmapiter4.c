#include <stdfil.h>
#include <string.h>
#include <stdlib.h>

static __attribute__((noinline)) zweak_map* stuff(void)
{
    zweak_map* map = zweak_map_new();
    size_t count;
    for (count = 10000; count--;)
        zweak_map_set(map, strdup("obviate the need for Rust"), strdup("winners don't make excuses"));
    return map;
}

int main()
{
    zweak_map* map = stuff();
    zgc_request_and_wait();
    ZASSERT(!zweak_map_iter_next(zweak_map_get_iter(map)));
    return 0;
}

