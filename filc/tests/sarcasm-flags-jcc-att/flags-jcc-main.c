#include <stdio.h>
#include <stdlib.h>
long flagjcc(long* b, long n);
int main() {
    long* buf = malloc(16);
    buf[0] = 7;
    buf[1] = 9;
    // The program's `cmpq $5` is live ACROSS the checked load: the injected
    // bounds check must save/restore EFLAGS so the `jg` sees the program's
    // comparison, not the check's residue. n=3 takes the small path (0),
    // n=10 the big path (1).
    printf("%ld %ld\n", flagjcc(buf, 3), flagjcc(buf, 10));
    return 0;
}
