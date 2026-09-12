#include <stdio.h>
extern void fp_hivec_poll(long *out, long *x, long n);
int main(void) {
    long x[12], out[12] = {0};
    for (int i = 0; i < 12; i++) x[i] = i + 1;
    fp_hivec_poll(out, x, 3000000);
    for (int i = 0; i < 12; i++)
        if (out[i] != x[i] * 3000000L) { printf("FAIL: out[%d]=%ld want %ld\n", i, out[i], x[i]*3000000L); return 1; }
    printf("fp hivec poll ok\n");
    return 0;
}
