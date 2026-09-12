#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void scalar_unaligned(unsigned char *p);

int main(void)
{
    unsigned char *p = malloc(32);
    if (!p)
        return 1;
    memset(p, 0, 32);
    scalar_unaligned(p);
    unsigned v;
    memcpy(&v, p + 1, 4);
    if (v != 1) {
        printf("FAIL movl %u\n", v);
        return 1;
    }
    unsigned short w;
    memcpy(&w, p + 7, 2);
    if (w != 2) {
        printf("FAIL movw %u\n", w);
        return 1;
    }
    unsigned long q;
    memcpy(&q, p + 9, 8);
    if (q != 3) {
        printf("FAIL movq %lu\n", q);
        return 1;
    }
    printf("unaligned scalar ok\n");
    return 0;
}
