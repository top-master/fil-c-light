#include <stdfil.h>

/* Without -yolo-assembler, the compiler does not recognize zunsafe_call, zunsafe_fast_call, or
   zunsafe_buf_call, so these definitions are just ordinary functions and the calls below go to
   them. If the compiler recognized the zunsafe intrinsics, the calls would instead go to the
   Yolo symbol "foo" and the ZASSERTs below would fail. */

unsigned long zunsafe_call(const char* symbol_name, ...)
{
    return 1410;
}

unsigned long zunsafe_fast_call(const char* symbol_name, ...)
{
    return 1411;
}

unsigned long zunsafe_buf_call(__SIZE_TYPE__ size, const char* symbol_name, ...)
{
    return 1412;
}

int main()
{
    ZASSERT(zunsafe_call("foo", 42, 666) == 1410);
    ZASSERT(zunsafe_fast_call("foo", 44, 668) == 1411);
    ZASSERT(zunsafe_buf_call(10, "foo", 46, 670) == 1412);
    return 0;
}
