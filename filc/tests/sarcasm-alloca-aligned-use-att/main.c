#include <stdio.h>

unsigned long alignuse_direct(unsigned long v);
unsigned long alignuse_and16(unsigned long v);
void *alignuse_dyn(unsigned long n);
void *alignuse_a32(void);

int main(void)
{
    /* Direct aligned vector traffic on a `.alloca $64,$16` result. */
    if (alignuse_direct(21) != 42) {
        printf("FAIL alignuse_direct got %lu\n", alignuse_direct(21));
        return 1;
    }
    /* The old `and $-16` idiom is a safe no-op on the aligned result. */
    if (alignuse_and16(21) != 21) {
        printf("FAIL alignuse_and16 got %lu\n", alignuse_and16(21));
        return 1;
    }
    /* Dynamic size: still 16-aligned, whole range writable. */
    for (unsigned long n = 1; n < 5; n++) {
        unsigned char *p = alignuse_dyn(n);
        if (((unsigned long)p & 15) != 0) {
            printf("FAIL alignuse_dyn align %lu\n", n);
            return 1;
        }
        unsigned long bytes = 32 + n * 8;
        for (unsigned long i = 0; i < bytes; i++)
            p[i] = (unsigned char)i;
        for (unsigned long i = 0; i < bytes; i++) {
            if (p[i] != (unsigned char)i) {
                printf("FAIL alignuse_dyn contents %lu\n", n);
                return 1;
            }
        }
    }
    /* $32 alignment satisfied, 32-byte vector traffic needs no masking. */
    void *q = alignuse_a32();
    if (((unsigned long)q & 31) != 0) {
        printf("FAIL alignuse_a32 align\n");
        return 1;
    }
    printf("alloca aligned use att ok\n");
    return 0;
}
