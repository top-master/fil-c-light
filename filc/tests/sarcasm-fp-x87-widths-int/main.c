#include <stdio.h>
#include <string.h>
#include <stdint.h>

void x87_dbl_roundtrip(void* in, void* out);
void x87_i64_roundtrip(void* in, void* out);
void x87_tbyte_roundtrip(void* in, void* out);

int main()
{
    /* full 8-byte double load/store, byte-exact */
    double d = 3.5;
    double d2 = 0.0;
    x87_dbl_roundtrip(&d, &d2);
    if (memcmp(&d, &d2, 8) != 0 || d2 != 3.5) {
        printf("dbl roundtrip failed: %a\n", d2);
        return 1;
    }

    /* 2^53+1: exact in 80-bit extended (64-bit significand), but a narrowed
       fild (2- or 4-byte load) truncates it. */
    uint64_t i = 9007199254740993ULL;
    uint64_t i2 = 0;
    x87_i64_roundtrip(&i, &i2);
    if (i2 != i) {
        printf("i64 roundtrip failed: %llu\n", (unsigned long long)i2);
        return 1;
    }

    /* 10-byte extended round-trip: 3.5 = sign 0, exp 0x4000,
       significand 0xC000000000000000 (little-endian). */
    unsigned char tin[16];
    unsigned char tout[16];
    memset(tin, 0, sizeof(tin));
    memset(tout, 0, sizeof(tout));
    tin[7] = 0xC0;
    tin[9] = 0x40;
    x87_tbyte_roundtrip(tin, tout);
    if (memcmp(tin, tout, 10) != 0) {
        printf("tbyte roundtrip failed\n");
        return 1;
    }

    printf("x87widths ok\n");
    return 0;
}
