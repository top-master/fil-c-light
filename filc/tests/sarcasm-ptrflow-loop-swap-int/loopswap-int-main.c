#include <stdio.h>
extern void loop_swap_ptr(long *out, long *a, long n);
int main(void) {
    long a[4] = {11, 22, 33, 44};
    long out[4] = {0, 0, 0, 0};
    loop_swap_ptr(out, a, 3);
    if (out[0] != 11) { printf("FAIL: out[0]=%ld want 11\n", out[0]); return 1; }
    printf("loop swap ptr ok\n");
    return 0;
}
