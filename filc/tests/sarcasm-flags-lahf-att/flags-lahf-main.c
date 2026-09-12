#include <stdio.h>
#include <stdlib.h>
long flaglahf(long* b);
int main() {
    long* buf = malloc(8);
    buf[0] = 5;
    // stc sets CF; the checked load (into %rcx, so the rax web stays live across
    // it) clobbers EFLAGS unless the injected check saves/restores them, and the
    // lahf must be modeled as an rax-web RMW pinned to physical rax. The result
    // is AH bit 0 = the program's carry (1), not the check's residue.
    printf("%ld\n", flaglahf(buf));
    return 0;
}
