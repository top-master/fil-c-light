#include <stdio.h>
#include <string.h>

void mbplain_run(void *src, void *dst);

int main(void) {
    unsigned char src[56], dst[56];
    for (int i = 0; i < 56; i++)
        src[i] = (unsigned char)(i * 7 + 3);
    memset(dst, 0, sizeof dst);
    mbplain_run(src, dst);
    if (memcmp(dst, src, sizeof dst) != 0) {
        printf("mb plain addr BAD\n");
        return 1;
    }
    printf("mb plain addr ok\n");
    return 0;
}
