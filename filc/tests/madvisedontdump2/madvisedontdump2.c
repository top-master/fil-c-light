#include <sys/mman.h>
#include <stdfil.h>
#include <inttypes.h>
#include <unistd.h>
#include <stdlib.h>

int main()
{
    void* m = zgc_aligned_alloc(getpagesize(), getpagesize());
    ZASSERT(m);
    ZASSERT(m != (void*)(intptr_t)-1);
    ZASSERT(!madvise(m, getpagesize(), MADV_DONTDUMP));
    return 0;
}
