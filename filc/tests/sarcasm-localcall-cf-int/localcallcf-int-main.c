#include <stdio.h>
extern long localcall_cf(long a, long b, long *xp);
int main(void) {
    long x = 0;
    long r1 = localcall_cf(3, 5, &x), r2 = localcall_cf(5, 3, &x);
    if (r1 != 1 || r2 != 0) { printf("FAIL: got %ld %ld want 1 0\n", r1, r2); return 1; }
    printf("localcall cf ok\n");
    return 0;
}
