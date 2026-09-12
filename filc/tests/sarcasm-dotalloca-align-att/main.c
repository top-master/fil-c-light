#include <stdio.h>

void *dotalloca_a16(void);
void *dotalloca_a32(void);
void *dotalloca_a64(void);
void *dotalloca_a128(void);

static int check(void *p, unsigned long align, unsigned long size)
{
    if (((unsigned long)p & (align - 1)) != 0) {
        printf("FAIL align %lu got %p\n", align, p);
        return 1;
    }
    /* The whole size must be writable through the returned pointer. */
    for (unsigned long i = 0; i < size; i++)
        ((unsigned char *)p)[i] = (unsigned char)(i & 0xff);
    for (unsigned long i = 0; i < size; i++) {
        if (((unsigned char *)p)[i] != (unsigned char)(i & 0xff)) {
            printf("FAIL contents %lu\n", align);
            return 1;
        }
    }
    return 0;
}

int main(void)
{
    if (check(dotalloca_a16(), 16, 48))
        return 1;
    if (check(dotalloca_a32(), 32, 48))
        return 1;
    if (check(dotalloca_a64(), 64, 48))
        return 1;
    if (check(dotalloca_a128(), 128, 200))
        return 1;
    printf("dotalloca align ok\n");
    return 0;
}
