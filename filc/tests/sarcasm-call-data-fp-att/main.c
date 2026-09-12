#include <stdio.h>

extern long asmentry(void);

/* Same as sarcasm-call-data-att, but the assembly callsite has a
   floating-point signature (double()). The weak callsite resolver
   pizlonatedFI4_foo must still reject the data object: the special-type,
   canonical-entrypoint and null checks run before the signature compare and
   are independent of the callsite's signature. */
long foo = 42;

int main()
{
    printf("%ld\n", asmentry());
    return 0;
}
