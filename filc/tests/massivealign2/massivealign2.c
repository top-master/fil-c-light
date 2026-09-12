#include <stdfil.h>

int main()
{
    void* ptr = zgc_alloc(1);
    ptr = zgc_aligned_realloc(ptr, 64 * 1024 * 1024, 1000);
    ZASSERT(ptr);
    return 0;
}

