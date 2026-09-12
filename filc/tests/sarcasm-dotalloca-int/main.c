#include <stdio.h>

long dotalloca_intel(long v);
long dotalloca_intel_slot(long v);

int main(void)
{
    if (dotalloca_intel(17) != 17) {
        printf("FAIL intel\n");
        return 1;
    }
    if (dotalloca_intel_slot(19) != 19) {
        printf("FAIL intel slot\n");
        return 1;
    }
    printf("dotalloca intel ok\n");
    return 0;
}
