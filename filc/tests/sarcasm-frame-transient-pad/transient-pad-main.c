#include <stdio.h>
long foo_transient(long);
long foo_prologue_save(long);
int main() {
    // foo_transient: the transient pushq %rbx / popq %rbx pair inside the prologue prefix
    // must NOT inflate frameSize: -8(%rbp) and 8(%rsp) are the same address (rbp = rsp+16),
    // so the argument stored via -8(%rbp) must be read back through 8(%rsp) -> 103.
    // foo_prologue_save: a prologue callee-saved push AFTER the frame pointer is
    // established legitimately counts toward frameSize (rbp = rsp+16 again): same
    // aliasing must hold, with an epilogue that restores through the saves -> 42.
    printf("%ld %ld\n", foo_transient(103), foo_prologue_save(42));
    return 0;
}
