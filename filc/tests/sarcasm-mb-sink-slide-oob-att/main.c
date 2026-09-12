#include <stdio.h>

void mbold_run(long iters);

int main(void) {
    printf("expect trap:\n");
    // 300 fully-sunk iterations against a 4096-byte sink in the old
    // sliding form: the sunk addresses reach base+4800, past the end.
    mbold_run(300);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
