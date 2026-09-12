#include <stdfil.h>

int main()
{
    zprintf("pointer = %p\n", zstack_pointer());
    zprintf("limit = %p\n", zstack_limit());
    zprintf("top = %p\n", zstack_top());
    ZASSERT(zstack_pointer());
    ZASSERT(zstack_limit());
    ZASSERT(zstack_top());
    ZASSERT(zstack_pointer() < __builtin_frame_address(0));
    ZASSERT(zstack_pointer() > zstack_limit());
    ZASSERT(zstack_pointer() < zstack_top());
    ZASSERT(!zhasvalidcap(zstack_pointer()));
    ZASSERT(!zhasvalidcap(zstack_limit()));
    ZASSERT(!zhasvalidcap(zstack_top()));
    return 0;
}

