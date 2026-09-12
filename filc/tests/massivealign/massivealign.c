#include <stdfil.h>

int main()
{
    void* ptr = zgc_aligned_alloc(64 * 1024 * 1024, 1);
    ZASSERT(ptr);
    return 0;
}

