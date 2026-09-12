#include <stdio.h>

extern long rbpsave_like(long *p);

int main(void)
{
    long v = 35;             /* result = 35 + 7 = 42 */
    long r = rbpsave_like(&v);
    if (r != 42) {
        printf("FAIL: got %ld, want 42\n", r);
        return 1;
    }
    printf("sp save rbp att ok\n");
    return 0;
}
