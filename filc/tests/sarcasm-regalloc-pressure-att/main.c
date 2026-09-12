#include <stdio.h>
#include <string.h>

void ecp_nistz256_sqr_mont(unsigned long r[4], const unsigned long a[4]);

/* P-256 Montgomery squaring: sqr_mont(k*R) = k^2*R (mod p), R = 2^256. */
static const unsigned long M1[4] = { 0x0000000000000001UL, 0xffffffff00000000UL,
    0xffffffffffffffffUL, 0x00000000fffffffeUL };   /* 1*R mod p */
static const unsigned long M2[4] = { 0x0000000000000002UL, 0xfffffffe00000000UL,
    0xffffffffffffffffUL, 0x00000001fffffffdUL };   /* 2*R mod p */
static const unsigned long M3[4] = { 0x0000000000000003UL, 0xfffffffd00000000UL,
    0xffffffffffffffffUL, 0x00000002fffffffcUL };   /* 3*R mod p */
static const unsigned long M4[4] = { 0x0000000000000004UL, 0xfffffffc00000000UL,
    0xffffffffffffffffUL, 0x00000003fffffffbUL };   /* 4*R mod p */
static const unsigned long M9[4] = { 0x0000000000000009UL, 0xfffffff700000000UL,
    0xffffffffffffffffUL, 0x00000008fffffff6UL };   /* 9*R mod p */

static int check(const unsigned long* in, const unsigned long* want, const char* what)
{
    unsigned long r[4] = { 0, 0, 0, 0 };
    ecp_nistz256_sqr_mont(r, in);
    if (memcmp(r, want, sizeof r)) {
        printf("FAIL %s: got %lx %lx %lx %lx\n", what, r[0], r[1], r[2], r[3]);
        return 1;
    }
    return 0;
}

void press(unsigned long r[4], const unsigned long a[4]);

int main()
{
    if (check(M1, M1, "sqr(1R) == 1R"))
        return 1;
    if (check(M2, M4, "sqr(2R) == 4R"))
        return 1;
    if (check(M3, M9, "sqr(3R) == 9R"))
        return 1;
    /* The distilled minimal repro (pressmin.s): same non-converging shape. It
       must compile and run (deterministically, without trapping). */
    unsigned long a[16] = {0};
    a[0] = 0x1111111111111111UL;
    a[1] = 0x2222222222222222UL;
    a[2] = 0x3333333333333333UL;
    a[3] = 0x4444444444444444UL;
    unsigned long r1[4] = {0}, r2[4] = {0};
    press(r1, a);
    press(r2, a);
    if (memcmp(r1, r2, sizeof r1)) {
        printf("FAIL pressmin: nondeterministic result\n");
        return 1;
    }
    printf("regalloc pressure att ok\n");
    return 0;
}
