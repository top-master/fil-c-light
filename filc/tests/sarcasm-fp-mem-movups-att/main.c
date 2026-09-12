#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void copy32(void* dst, void* src);
void copy32_rev(void* dst, void* src);

int main()
{
    unsigned char* src = malloc(32);
    unsigned char* dst = malloc(32);
    unsigned char* dst2 = malloc(32);
    if (!src || !dst || !dst2)
        return 1;
    int i;
    for (i = 0; i < 32; i++)
        src[i] = (unsigned char)(0xA0 + i * 7);
    memset(dst, 0, 32);
    memset(dst2, 0, 32);
    copy32(dst, src);
    copy32_rev(dst2, src);
    if (memcmp(dst, src, 32))
        return 1;
    if (memcmp(dst2, src, 32))
        return 1;
    printf("movups ok\n");
    return 0;
}
