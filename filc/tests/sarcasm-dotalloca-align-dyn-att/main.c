#include <stdio.h>

void *dotalloca_adyn(long size, long align);

static int check(long size, long align)
{
    void *p = dotalloca_adyn(size, align);
    if (((unsigned long)p & ((unsigned long)align - 1)) != 0) {
        printf("FAIL align %ld got %p\n", align, p);
        return 1;
    }
    for (long i = 0; i < size; i++)
        ((unsigned char *)p)[i] = (unsigned char)(i & 0xff);
    for (long i = 0; i < size; i++) {
        if (((unsigned char *)p)[i] != (unsigned char)(i & 0xff)) {
            printf("FAIL contents %ld\n", align);
            return 1;
        }
    }
    return 0;
}

int main(void)
{
    if (check(48, 1))
        return 1;
    if (check(48, 8))
        return 1;
    if (check(48, 16))
        return 1;
    if (check(48, 32))
        return 1;
    if (check(200, 64))
        return 1;
    if (check(200, 128))
        return 1;
    printf("dotalloca align dyn ok\n");
    return 0;
}
