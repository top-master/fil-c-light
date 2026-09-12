#include <stdio.h>
long foo_movrbp(long);
long foo_nolocals(long);
int main() {
    // Both functions tear the frame down with `movq %rbp, %rsp; popq %rbp; ret` instead
    // of `leave; ret`: the frame-pointer restore teardown path must assemble and run
    // correctly. foo_movrbp also checks that -8(%rbp) and 8(%rsp) stay the same slot
    // (rbp = rsp + 16) across that teardown.
    printf("%ld %ld\n", foo_movrbp(41), foo_nolocals(39));
    return 0;
}
