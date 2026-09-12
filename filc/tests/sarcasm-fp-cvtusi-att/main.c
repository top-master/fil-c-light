#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

void cvt_ss(void* out);
void cvt_sd(void* out);
long cvt_back_d(void* in);
long cvt_back_s(void* in);
void cvtmem_ss(void* in, void* out);
void cvtmem_sd(void* in, void* out);

int main()
{
    uint32_t f32;
    uint64_t f64, expect64;
    uint32_t expect32;

    /* 6*7 = 42 converted from the post-imul register value: 42.0f = 0x42280000 */
    cvt_ss(&f32);
    if (f32 != 0x42280000u) {
        printf("cvt_ss bits %08x\n", f32);
        return 1;
    }

    /* 123456789*97 = 11975308533 (< 2^53, exactly representable) */
    cvt_sd(&f64);
    double expect_sd = 11975308533.0;
    memcpy(&expect64, &expect_sd, 8);
    if (f64 != expect64) {
        printf("cvt_sd bits %016lx\n", (unsigned long)f64);
        return 1;
    }

    /* truncation back to integer, result used in integer arithmetic */
    double d = 123.9;
    if (cvt_back_d(&d) != 130)
        return 1;
    float f = 99.9f;
    if (cvt_back_s(&f) != 100)
        return 1;

    /* m64 mem forms: 8-byte load at offset 8 of a 16-byte object (exact end).
       2^64-1 converts to 2^64 in both precisions. */
    char* buf = malloc(16);
    if (!buf)
        return 1;
    uint64_t big = ~0ULL;
    memcpy(buf + 8, &big, 8);
    cvtmem_ss(buf + 8, &f32);
    float expect_f = 0x1p+64f;
    memcpy(&expect32, &expect_f, 4);
    if (f32 != expect32) {
        printf("cvtmem_ss bits %08x want %08x\n", f32, expect32);
        return 1;
    }
    cvtmem_sd(buf + 8, &f64);
    double expect_d = 0x1p+64;
    memcpy(&expect64, &expect_d, 8);
    if (f64 != expect64) {
        printf("cvtmem_sd bits %016lx\n", (unsigned long)f64);
        return 1;
    }
    printf("cvtusi ok\n");
    return 0;
}
