#include <stdio.h>

void mboob_run(void);

int main(void) {
    printf("expect trap:\n");
    // A by-address read at the offd window's top edge must trap.
    mboob_run();
    printf("SHOULD NOT PRINT\n");
    return 0;
}
