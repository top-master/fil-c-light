#include <stdio.h>

void mb32old_run(long iters);

int main(void) {
    printf("expect trap:\n");
    // 4 sunk-store iterations against a 32-byte sink in the old sliding
    // form: iteration 2 reaches base+32, one past the end.
    mb32old_run(4);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
