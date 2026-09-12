#include <stdio.h>

long addmul(long a, long b, long c);

int main()
{
    /* Calling through a function pointer whose type's signature differs from the
       function object forces the call through the generic (buffer marshalling)
       entrypoint pizlonated2ET<sig> emitted by sarcasm. Both sides use 3 words of
       args, so the call is well-defined in Fil-C. */
    long (*volatile fp)(void*, long, long) = (long (*)(void*, long, long))addmul;
    printf("indirect: %ld\n", fp((void*)6, 7, 3));  /* 6*7+3 = 45, generic entrypoint */
    printf("direct: %ld\n", addmul(2, 3, 4));       /* 2*3+4 = 10, fast entrypoint */
    return 0;
}
