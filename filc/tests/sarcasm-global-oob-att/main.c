/* An index past the end of a same-file table traps: the seeded pointer's
   capability is the data object's payload, so the bounds check fires
   exactly like a C array access. */
#include <stdio.h>
long ktab_get(long i);
int main()
{
    printf("expect trap:\n");
    ktab_get(4);   /* one past the end of the 4-element table */
    printf("SHOULD NOT PRINT\n");
    return 0;
}
