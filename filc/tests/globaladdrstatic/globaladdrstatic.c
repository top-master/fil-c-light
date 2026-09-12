#include <stdfil.h>
#include <inttypes.h>

static int x;

int main()
{
    ZASSERT((uintptr_t)&x >= 0x100000000);
    return 0;
}

