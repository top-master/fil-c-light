#include <stdio.h>

/* A pointer ARGUMENT round-trips through frame slots (rbp-relative and
   rsp-relative) across a call: the reloaded web must stay pointer-typed,
   so the write/read through the reload land in the caller's buffer.
   foo writes '*' (42) at buf[0], then foo2 (called with the pointer
   reloaded out of a slot) overwrites it with '!' (33); foo returns
   42 + 33 + 42 = 117. */
extern long foo(char *p, long v);
extern void foo2(char *p);

int main(void)
{
    char buf[8] = "hello";
    long r = foo(buf, 42);
    if (buf[0] == '!' && r == 117)
        printf("ok\n");
    else
        printf("bad %d %ld\n", buf[0], r);
    return 0;
}
