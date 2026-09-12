#include <stdfil.h>

int main()
{
    void* ptr;
    asm volatile("" : "=r"(ptr) : : "memory");
    ZASSERT(!zhasvalidcap(ptr));
    ZASSERT(!zgetlower(ptr));
    ZASSERT(!zgetupper(ptr));
    return 0;
}

