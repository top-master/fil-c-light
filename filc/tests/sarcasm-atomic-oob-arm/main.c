#include <stdio.h>
#include <stdlib.h>

/* ldadd one long past the end of a 16-byte object: the upper-bound check
   must fire (an atomic RMW is a write, so the message is the write form). */
void f(long* p, long v);

int main()
{
    long* buf = malloc(16);
    printf("expect trap:\n");
    fflush(stdout);
    f(buf + 2, 1);              /* exactly at the upper bound */
    printf("SHOULD NOT PRINT\n");
    return 0;
}
