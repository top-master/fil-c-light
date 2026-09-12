#include <stdio.h>

long iframed(long x);

int main(void)
{
    /* Intel-syntax input with byte-encoded endbr64 / sub rsp,8 / rep ret:
       iframed(x) = x + 7. */
    if (iframed(35) != 42) {
        printf("iframed = %ld\n", iframed(35));
        return 1;
    }
    printf("bytes frame int ok\n");
    return 0;
}
