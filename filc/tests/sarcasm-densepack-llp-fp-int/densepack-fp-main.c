#include <stdio.h>

/* Same dense-packing regression shape as sarcasm-densepack-llp-*, but the call goes
   through a function pointer, exercising sarcasm's generic (buffer marshalling)
   entrypoint pizlonated2ET<sig>: that thunk reads the argument buffer and repacks
   the words densely into rdx,rcx,r8,r9 (a pointer arg = two words) before tail-
   calling the fast entrypoint, so the scalars-then-pointer shape discriminates
   here too (old fixed-pair packing traps on a null-lower capability).

   Note: a CORRECTLY-typed function pointer would not exercise the generic path at
   all — the caller checks the function object's signature and calls the fast
   entrypoint directly when it matches. The deliberately mismatched pointer type
   below (extra 4th arg) forces the generic path. It keeps slot-wise class
   compatibility for the three real arguments (scalar, scalar, pointer), so the
   pointer capability transfers in a well-defined way, and the generic CC simply
   lets the callee ignore the extra word. */
long llp(long a, long b, long* p);

int main()
{
    long x = 3;
    long (*volatile fp)(long, long, long*, long) =
        (long (*)(long, long, long*, long))llp;
    printf("%ld\n", fp(40, 60, &x, 999));   /* 40 + 60 + *p = 103, generic entrypoint */
    return 0;
}
