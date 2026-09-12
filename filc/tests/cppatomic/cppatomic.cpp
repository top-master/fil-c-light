#include <atomic>
#include <stdfil.h>

using namespace	std;

int main()
{
    int	x;
    atomic<int*> p = &x;
    int *q = p.fetch_sub(42);
    ZASSERT(q == &x);
    ZASSERT(p == &x - 42);
    q = p.fetch_add(666);
    ZASSERT(q == &x - 42);
    ZASSERT(p == &x + 666 - 42);
    q = p -= 42;
    ZASSERT(q == &x + 666 - 42 - 42);
    ZASSERT(p == &x + 666 - 42 - 42);
    q = p += 666;
    ZASSERT(q == &x + 666 - 42 - 42 + 666);
    ZASSERT(p == &x + 666 - 42 - 42 + 666);
    return 0;
}
