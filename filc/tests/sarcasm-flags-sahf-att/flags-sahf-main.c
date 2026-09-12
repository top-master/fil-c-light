#include <stdio.h>
#include <stdlib.h>
long flagsahf(long* b);
int main() {
    long* buf = malloc(8);
    buf[0] = 5;
    // stc sets CF; lahf captures the flag byte into the rax web's AH (bits 8-15);
    // the checked load into %rcx would clobber EFLAGS; sahf restores SF/ZF/AF/PF/CF
    // from the web's AH (wherever regalloc colored it) — modeled as a uses-only
    // pin to physical rax. `jc` must then see the program's carry (1).
    printf("%ld\n", flagsahf(buf));
    return 0;
}
