#include <stdio.h>
#include <string.h>

extern void foo(unsigned long *buf);

int main(void)
{
    unsigned long buf[6];
    memset(buf, 0, sizeof buf);
    buf[0] = 100;
    buf[1] = 23;
    foo(buf);
    /* triple: out = in + 2*(in copy). buf[2..3] = 3*buf[0..1]; buf[4..5] = 3*that. */
    if (buf[2] != 300 || buf[3] != 69 || buf[4] != 900 || buf[5] != 207) {
        printf("FAIL: %lu %lu %lu %lu\n", buf[2], buf[3], buf[4], buf[5]);
        return 1;
    }
    printf("localcall xmm att ok\n");
    return 0;
}
