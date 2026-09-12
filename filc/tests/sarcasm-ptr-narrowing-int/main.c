#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

long narrow_zx(void* p);
long narrow_sx_byte(void* p);
long narrow_sxd(void* p);

int main()
{
    char* buf = malloc(16);
    if (!buf)
        return 1;
    memset(buf, 0, 16);

    /* WORD at offset 14: a 2-byte load ending exactly at the end of the
       16-byte object (over-checking at the 4-byte destination width would
       trap). */
    buf[14] = 0x34;
    buf[15] = 0x12;
    if (narrow_zx(buf + 14) != 0x1234)
        return 1;
    buf[14] = 0xEF;
    buf[15] = 0xBE;
    if (narrow_zx(buf + 14) != 0xBEEF)   /* zero-extended, not sign-extended */
        return 1;

    /* BYTE at offset 15: 1-byte load at the exact end. */
    buf[15] = 0x7F;
    if (narrow_sx_byte(buf + 15) != 127)
        return 1;
    buf[15] = 0x80;
    /* sign-extended into eax: 0xFFFFFF80 (zero-extends to rax) */
    if (narrow_sx_byte(buf + 15) != (long)(uint32_t)0xFFFFFF80u)
        return 1;

    /* DWORD at offset 12: 4-byte load ending exactly at the end. */
    uint32_t v = 0x7FFFFFFFu;
    memcpy(buf + 12, &v, 4);
    if (narrow_sxd(buf + 12) != 0x7FFFFFFF)
        return 1;
    v = 0x80000000u;
    memcpy(buf + 12, &v, 4);
    if (narrow_sxd(buf + 12) != (long)-2147483647 - 1)   /* sign-extended to 64 bits */
        return 1;

    printf("narrowing ok\n");
    return 0;
}
