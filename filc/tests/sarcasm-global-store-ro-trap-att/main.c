/* A store to a same-file readonly table traps in the access check's
   CanWrite test (the data object's aux flags carry ObjectFlagReadonly),
   exactly like a store to a const C global in compiled code. */
#include <stdio.h>
void badstore(long v);
int main()
{
    printf("expect trap:\n");
    badstore(5);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
