#include <stdio.h>
#include <stdlib.h>
long flaglahf(long* b);
int main() {
    long* buf = malloc(8);
    buf[0] = 5;
    // Same shape as the success variant, but the checked access is out of
    // bounds: the check's fail path fires between the two halves of the flag
    // bracket (after pushfq/popq, skipping pushq/popfq — each pair is
    // stack-neutral on its own) and the fail stub traps.
    printf("expect trap:\n");
    printf("%ld SHOULD NOT PRINT\n", flaglahf(buf + 1000000));
    return 0;
}
