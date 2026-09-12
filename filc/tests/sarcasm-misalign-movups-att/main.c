#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void movups_misaligned(unsigned char *dst, unsigned char *src);

int main(void)
{
    unsigned char *src = malloc(64);
    unsigned char *dst = malloc(64);
    if (!src || !dst)
        return 1;
    for (int i = 0; i < 64; i++)
        src[i] = (unsigned char)(i + 1);
    memset(dst, 0, 64);
    movups_misaligned(dst, src);
    if (memcmp(dst + 1, src + 1, 16) != 0) {
        printf("FAIL movups\n");
        return 1;
    }
    if (memcmp(dst + 3, src + 3, 16) != 0) {
        printf("FAIL movdqu\n");
        return 1;
    }
    if (memcmp(dst + 17, src + 17, 16) != 0) {
        printf("FAIL movups17\n");
        return 1;
    }
    printf("movups misaligned ok\n");
    return 0;
}
