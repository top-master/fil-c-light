#include <stdfil.h>

/* foo's callsite declares the callee as int(ptr) but bar is really int(int):
   a signature mismatch at the indirect call, which must take the generic
   buffer-CC path and still produce the right answer (the two signatures are
   call-compatible for an all-integer call). */
int foo(int (*f)(int), int a);

int bar(int a)
{
    return a + 67;
}

int main()
{
    ZASSERT(foo(bar, 666) == 666 + 67);
    return 0;
}
