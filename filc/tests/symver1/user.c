#include <stdfil.h>

int foo(void);

int main()
{
    int result = foo();
    zprintf("result = %d\n", result);
    /* NOTE: It's a bug that this might return 666. That bug is due to musl's dynlinker.
       
       If we had a gnu-compliant dynlinker, then the result could only be 1410. */
    ZASSERT(result == 1410 || result == 666);
    return 0;
}
