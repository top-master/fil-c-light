#include <stdio.h>

long pseudo_iso_a(long a);
long pseudo_iso_b(long b);

int main(void)
{
    /* Interleave calls: each file's pseudos must hold that file's values. */
    if (pseudo_iso_a(21) != 42) {
        printf("FAIL iso_a\n");
        return 1;
    }
    if (pseudo_iso_b(21) != 47) {
        printf("FAIL iso_b\n");
        return 1;
    }
    if (pseudo_iso_a(1) != 2 || pseudo_iso_b(1) != 7) {
        printf("FAIL iso_interleaved\n");
        return 1;
    }
    if (pseudo_iso_a(-3) != -6 || pseudo_iso_b(-3) != -1) {
        printf("FAIL iso_negative\n");
        return 1;
    }
    printf("pseudo isolate ok\n");
    return 0;
}
