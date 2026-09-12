#include <stdio.h>

extern long asmentry(void);

/* The canonical negative case: a C translation unit exports a DATA variable
   named `foo`, while the assembly module calls `foo` as a function. The call
   goes through the weak callsite resolver (pizlonatedFI2_foo), which resolves
   the object via the data getter pizlonated_foo and must reject it: a data
   object is not a function object, so the special-type check panics before
   anything is called. */
long foo = 42;

int main()
{
    /* First and only call: the panic must happen here, inside asmentry. */
    printf("%ld\n", asmentry());
    return 0;
}
