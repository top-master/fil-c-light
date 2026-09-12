#include <stdfil.h>

/* foo's callsite declares the callee as long(ptr) but bar is really long(long):
   a signature mismatch at the indirect call, which must take the generic
   buffer-CC path and still produce the right answer (the two signatures are
   call-compatible for an all-integer call). */
long foo(long (*f)(long), long a);

long bar(long a)
{
    return a + 67;
}

int main()
{
    ZASSERT(foo(bar, 666) == 666 + 67);
    return 0;
}
