#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <math.h>

#ifdef __x86_64__
#include <cpuid.h>
#endif

void cvt_pd2uqq(void* in, void* out);
void cvt_tpd2uqq(void* in, void* out);
void dq2ph_att(void* in, void* out);
void udq2ph_att(void* in, void* out);
void dq2ph_x_att(void* in, void* out);
void dq2ph_y_att(void* in, void* out);
void udq2ph_x_att(void* in, void* out);
void udq2ph_y_att(void* in, void* out);
void dq2ph_int(void* in, void* out);
void udq2ph_int(void* in, void* out);

/* vcvtdq2ph/vcvtudq2ph are AVX512-FP16 instructions: they can only EXECUTE
   where CPUID.7.0:EDX[23] (AVX512-FP16) is present. The .s files assemble
   unconditionally (proving sarcasm accepts the bare/x/y/ZMMWORD forms —
   the fix); the value checks below are gated on the silicon. */
static int have_fp16(void)
{
#ifdef __x86_64__
    unsigned eax = 0x7, ebx, ecx = 0, edx;
    __get_cpuid_count(0x7, 0, &eax, &ebx, &ecx, &edx);
    return (edx & (1u << 23)) != 0;
#else
    return 0;
#endif
}

/* C reference: unsigned magnitude -> IEEE binary16 bits, round-to-nearest-even
   (the default MXCSR rounding vcvtdq2ph/vcvtudq2ph use). Validated
   exhaustively against F16C vcvtps2ph over +-200000 plus extremes (exact for
   dword sources: no subnormal input is possible and every finite case keeps
   an exact intermediate). */
static uint16_t half_from_u32_rne(uint32_t a, int neg)
{
    uint16_t sign = neg ? 0x8000 : 0;
    if (!a)
        return sign;
    int msb = 31 - __builtin_clz(a);
    int exp = msb + 15;              /* biased half exponent */
    if (exp >= 31)
        return sign | 0x7c00;        /* overflow -> inf */
    uint32_t mant;
    if (msb <= 10) {
        mant = a << (10 - msb);      /* top bit lands on the implicit bit */
    } else {
        int sh = msb - 10;
        uint32_t kept = a >> sh;
        uint32_t rem = a & ((1u << sh) - 1);
        uint32_t halfway = 1u << (sh - 1);
        mant = kept;
        if (rem > halfway || (rem == halfway && (kept & 1)))
            mant++;
        if (mant & 0x800) {          /* rounding carried into the exponent */
            mant >>= 1;
            exp++;
            if (exp >= 31)
                return sign | 0x7c00;
        }
    }
    return sign | (uint16_t)(exp << 10) | (uint16_t)(mant & 0x3ff);
}

static uint16_t ref_dq2ph(int32_t v)
{
    if (v < 0)
        return half_from_u32_rne((uint32_t)(-(int64_t)v), 1);
    return half_from_u32_rne((uint32_t)v, 0);
}

static uint16_t ref_udq2ph(uint32_t v)
{
    return half_from_u32_rne(v, 0);
}

int main()
{
    /* vcvtpd2uqq / vcvttpd2uqq (AVX512DQ): always executed here.
       Expected values cross-checked against Zen 5 hardware. Out-of-range
       (negative, NaN, > UINT64_MAX) yields the 64-bit unsigned integer
       indefinite 0xFFFFFFFFFFFFFFFF (SDM); a negative value that rounds/
       truncates to -0 is in range and converts to 0. */
    static double d_rne[8] = { 10.5, 11.5, -0.5, -1.0,
                               9007199254740992.0, 1.8e19, 1e20, NAN };
    static const uint64_t e_rne[8] = {
        10,                          /* RNE tie to even */
        12,                          /* RNE tie to even */
        0,                           /* -0.5 -> -0 -> 0 */
        0xFFFFFFFFFFFFFFFFULL,       /* -1.0 out of range */
        9007199254740992ULL,         /* 2^53 */
        0xF9CCD8A1C5080000ULL,       /* 1.8e19, exact */
        0xFFFFFFFFFFFFFFFFULL,       /* 1e20 > UINT64_MAX */
        0xFFFFFFFFFFFFFFFFULL        /* NaN */
    };
    static double d_trunc[8] = { 11.5, -0.9, -1.0, 3.7,
                                 9223372036854775808.0, 1.8e19, 1e20, 0.9 };
    static const uint64_t e_trunc[8] = {
        11,                          /* truncation drops .5 */
        0,                           /* -0.9 -> -0 -> 0 */
        0xFFFFFFFFFFFFFFFFULL,       /* -1.0 out of range */
        3,
        0x8000000000000000ULL,       /* 2^63, in range */
        0xF9CCD8A1C5080000ULL,       /* 1.8e19, exact */
        0xFFFFFFFFFFFFFFFFULL,       /* 1e20 > UINT64_MAX */
        0
    };
    double* in_rne = malloc(64);     /* 64-byte object filled exactly by the m512 read */
    double* in_trunc = malloc(64);
    uint64_t* out_rne = malloc(64);
    uint64_t* out_trunc = malloc(64);
    if (!in_rne || !in_trunc || !out_rne || !out_trunc)
        return 1;
    memcpy(in_rne, d_rne, 64);
    memcpy(in_trunc, d_trunc, 64);
    memset(out_rne, 0, 64);
    memset(out_trunc, 0, 64);
    cvt_pd2uqq(in_rne, out_rne);
    cvt_tpd2uqq(in_trunc, out_trunc);
    int i;
    for (i = 0; i < 8; i++) {
        if (out_rne[i] != e_rne[i]) {
            printf("pd2uqq[%d]: got %llu want %llu\n", i,
                   (unsigned long long)out_rne[i], (unsigned long long)e_rne[i]);
            return 1;
        }
        if (out_trunc[i] != e_trunc[i]) {
            printf("tpd2uqq[%d]: got %llu want %llu\n", i,
                   (unsigned long long)out_trunc[i], (unsigned long long)e_trunc[i]);
            return 1;
        }
    }

    /* vcvtdq2ph / vcvtudq2ph value checks — only where FP16 silicon exists.
       The forms were still fully assembled above (that is the regression:
       they used to be rejected/under-checked). */
    if (have_fp16()) {
        static const int32_t svals[16] = {
            0, 1, -1, 2, 1000, -1000, 2048, 2049,
            -2049, 4097, 65504, 65519, 65520, -65520, 123456789, INT32_MIN
        };
        static const uint32_t uvals[16] = {
            0u, 1u, 2u, 31u, 1000u, 2048u, 2049u, 4097u,
            65504u, 65519u, 65520u, 70000u, 123456789u, 4000000000u,
            4294967295u, 4294967294u
        };
        int32_t* sin = malloc(64);   /* m512 source filled exactly */
        uint32_t* uin = malloc(64);
        uint16_t* h = malloc(32);
        uint16_t* h2 = malloc(32);
        int32_t* sin16 = malloc(16); /* m128 source for the x forms */
        uint32_t* uin16 = malloc(16);
        int32_t* sin32 = malloc(32); /* m256 source for the y forms */
        uint32_t* uin32 = malloc(32);
        uint16_t* hx = malloc(16);   /* xmm dest: 8 halfs, x form fills the low 4 */
        uint16_t* hy = malloc(16);
        if (!sin || !uin || !h || !h2 || !sin16 || !uin16 || !sin32 || !uin32 || !hx || !hy)
            return 1;
        memcpy(sin, svals, 64);
        memcpy(uin, uvals, 64);
        memcpy(sin16, svals, 16);
        memcpy(uin16, uvals, 16);
        memcpy(sin32, svals, 32);
        memcpy(uin32, uvals, 32);

        /* bare AT&T m512 forms (64-byte check) and the Intel ZMMWORD PTR
           forms: same inputs, same expected halfs. */
        dq2ph_att(sin, h);
        for (i = 0; i < 16; i++) {
            uint16_t want = ref_dq2ph(svals[i]);
            if (h[i] != want) {
                printf("dq2ph[%d]: got %04x want %04x\n", i, h[i], want);
                return 1;
            }
        }
        memset(h2, 0xAA, 32);
        dq2ph_int(sin, h2);
        for (i = 0; i < 16; i++) {
            uint16_t want = ref_dq2ph(svals[i]);
            if (h2[i] != want) {
                printf("dq2ph int[%d]: got %04x want %04x\n", i, h2[i], want);
                return 1;
            }
        }
        memset(h, 0, 32);
        udq2ph_att(uin, h);
        for (i = 0; i < 16; i++) {
            uint16_t want = ref_udq2ph(uvals[i]);
            if (h[i] != want) {
                printf("udq2ph[%d]: got %04x want %04x\n", i, h[i], want);
                return 1;
            }
        }
        memset(h2, 0xAA, 32);
        udq2ph_int(uin, h2);
        for (i = 0; i < 16; i++) {
            uint16_t want = ref_udq2ph(uvals[i]);
            if (h2[i] != want) {
                printf("udq2ph int[%d]: got %04x want %04x\n", i, h2[i], want);
                return 1;
            }
        }

        /* x suffix: m128 source -> 4 halfs, upper half of the xmm dest zero. */
        memset(hx, 0xAA, 16);
        dq2ph_x_att(sin16, hx);
        for (i = 0; i < 8; i++) {
            uint16_t want = (i < 4) ? ref_dq2ph(svals[i]) : 0;
            if (hx[i] != want) {
                printf("dq2phx[%d]: got %04x want %04x\n", i, hx[i], want);
                return 1;
            }
        }
        memset(hx, 0xAA, 16);
        udq2ph_x_att(uin16, hx);
        for (i = 0; i < 8; i++) {
            uint16_t want = (i < 4) ? ref_udq2ph(uvals[i]) : 0;
            if (hx[i] != want) {
                printf("udq2phx[%d]: got %04x want %04x\n", i, hx[i], want);
                return 1;
            }
        }

        /* y suffix: m256 source -> 8 halfs. */
        memset(hy, 0xAA, 16);
        dq2ph_y_att(sin32, hy);
        for (i = 0; i < 8; i++) {
            uint16_t want = ref_dq2ph(svals[i]);
            if (hy[i] != want) {
                printf("dq2phy[%d]: got %04x want %04x\n", i, hy[i], want);
                return 1;
            }
        }
        memset(hy, 0xAA, 16);
        udq2ph_y_att(uin32, hy);
        for (i = 0; i < 8; i++) {
            uint16_t want = ref_udq2ph(uvals[i]);
            if (hy[i] != want) {
                printf("udq2phy[%d]: got %04x want %04x\n", i, hy[i], want);
                return 1;
            }
        }
        printf("fp16 value checks done\n");
    } else {
        printf("no avx512-fp16: dq2ph value checks skipped (forms still assembled)\n");
    }

    printf("cvt dq2ph ok\n");
    return 0;
}
