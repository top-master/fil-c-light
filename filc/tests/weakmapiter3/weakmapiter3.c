#include <stdfil.h>

int main()
{
    ZASSERT(!zweak_map_iter_next(zweak_map_get_iter(zweak_map_new())));
    return 0;
}

