#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

long farptr_lgs32(void* p);
long farptr_lgs16(void* p);

int main()
{
    /* 6-byte far pointer: offset 0x12345678, selector 0. Loading gs with a
       null selector is safe in-process (unlike fs, whose base would be
       zeroed on this machine). */
    unsigned char* buf = malloc(6);
    if (!buf)
        return 1;
    buf[0] = 0x78;
    buf[1] = 0x56;
    buf[2] = 0x34;
    buf[3] = 0x12;
    buf[4] = 0x00;
    buf[5] = 0x00;

    long r = farptr_lgs32(buf);
    if ((uint32_t)r != 0x12345678) {
        printf("lgs32 offset: got %08lx want 12345678\n", (uint32_t)r);
        return 1;
    }
    if ((uint32_t)(r >> 32) != 0) {
        printf("lgs32 selector: got %08lx want 0\n", (uint32_t)(r >> 32));
        return 1;
    }

    long r2 = farptr_lgs16(buf);
    if ((uint32_t)r2 != 0x1234) {
        printf("lgs16 offset: got %08lx want 00001234\n", (uint32_t)r2);
        return 1;
    }
    if ((uint32_t)(r2 >> 32) != 0) {
        printf("lgs16 selector: got %08lx want 0\n", (uint32_t)(r2 >> 32));
        return 1;
    }

    printf("farptr ok\n");
    return 0;
}
