#include <stdio.h>
#include <string.h>

void copy5w(char *dst, const char *src, size_t n);

static char src[64];
static char dst[64];

static int check(size_t n)
{
    memset(dst, 0xAA, sizeof(dst));
    copy5w(dst, src, n);
    for (size_t i = 0; i < n; i++)
        if (dst[i] != src[i])
            return 0;
    /* nothing past n may be touched */
    for (size_t i = n; i < sizeof(dst); i++)
        if (dst[i] != (char)0xAA)
            return 0;
    return 1;
}

int main()
{
    for (size_t i = 0; i < sizeof(src); i++)
        src[i] = (char)(i * 3 + 1);
    int ok = 1;
    /* many invocations, incl. 0, 1 and odd sizes around the word boundary */
    for (size_t n = 0; n <= sizeof(src); n++)
        ok = ok && check(n);
    printf(ok ? "sig5w ok\n" : "sig5w FAIL\n");
    return 0;
}
