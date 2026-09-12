#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

/* f_half(buf, float_bits(a), float_bits(b)) computes a+b, a*b, a-b, a/b in
   fp16, stores a+b (as double) at buf[0..8) and a*b (as half) at buf[14..16),
   and returns the sum of the five truncated halves:
   (2.5, 0.5): 3 + 1 + 2 + 5 + 1 = 12; (7.5, 1.5): 9 + 11 + 6 + 5 + 11 = 42. */
long f_half(void* buf, long abits, long bbits);

static long fbits(float f)
{
    uint32_t u;
    memcpy(&u, &f, 4);
    return u;
}

int main()
{
    char* buf = malloc(16);
    if (!buf)
        return 1;
    memset(buf, 0, 16);
    long r1 = f_half(buf, fbits(2.5f), fbits(0.5f));
    double d1;
    memcpy(&d1, buf, 8);
    if (d1 != 3.0) {
        printf("half BAD store %g\n", d1);
        return 1;
    }
    long r2 = f_half(buf, fbits(7.5f), fbits(1.5f));
    memcpy(&d1, buf, 8);
    if (d1 != 9.0) {
        printf("half BAD store %g\n", d1);
        return 1;
    }
    printf("half %ld %ld\n", r1, r2);
    return 0;
}
