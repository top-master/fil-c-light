#include <stdio.h>

long frameexpr(long x);
long dispexpr_load(long *p);
void dispexpr_store(long *p, long v);
long shiftexpr(void);

int main(void)
{
    if (frameexpr(123456789) != 123456789) {
        printf("frameexpr mismatch\n");
        return 1;
    }
    static long buf[80]; /* 640 bytes */
    buf[49] = 424242;    /* byte offset 392 == 512-128+8 */
    if (dispexpr_load(buf) != 424242) {
        printf("dispexpr_load mismatch: %ld\n", dispexpr_load(buf));
        return 1;
    }
    dispexpr_store(buf, 987654321);
    if (buf[64] != 987654321) {   /* byte offset 512 == 1024-512 */
        printf("dispexpr_store mismatch\n");
        return 1;
    }
    if (shiftexpr() != 81) {
        printf("shiftexpr mismatch: %ld\n", shiftexpr());
        return 1;
    }
    printf("ok\n");
    return 0;
}
