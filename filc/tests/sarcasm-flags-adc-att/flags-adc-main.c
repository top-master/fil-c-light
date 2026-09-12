#include <stdio.h>
#include <stdlib.h>
long flagadc(long* b, long n);
int main() {
    long* buf = malloc(8);
    buf[0] = 5;
    // stc sets CF; the injected bounds check for the checked `adcq (mem)` operand
    // must save/restore EFLAGS, so the adc carries the program's carry-in:
    // 10 + 5 + 1 = 16. (Without the flag bracket the check's own cmp residue
    // would feed the carry instead.)
    printf("%ld\n", flagadc(buf, 10));
    return 0;
}
