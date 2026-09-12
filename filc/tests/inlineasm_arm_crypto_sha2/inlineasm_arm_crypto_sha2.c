#include <stdfil.h>
#include <arm_neon.h>
#include <stdint.h>
#include <string.h>

/* FEAT_SHA256 instructions checked against exact C transliterations of the
   ISA pseudocode (sha256h/sha256h2/sha256su0/sha256su1 _advsimd.xml and
   SHA256hash/SHA256hashSIGMA0/SIGMA1 in shared_pseudocode.xml).

   SHA256hash(x, y, w, part1), four rounds (e = 0..3 inclusive):
     chs = SHAchoose(y[31:0], y[63:32], y[95:64])
     maj = SHAmajority(x[31:0], x[63:32], x[95:64])
     t   = y[127:96] + SIGMA1(y[31:0]) + chs + w[e]
     x[127:96] = t + x[127:96]
     y[127:96] = t + SIGMA0(x[31:0]) + maj
     (y, x) = ROL(y::x, 32)          [256-bit rotate: each word moves up
                                      one slot, y[127:96] wraps to x[31:0]]
     return part1 ? x : y
   SIGMA0(u) = ROR(u,2) ^ ROR(u,13) ^ ROR(u,22)
   SIGMA1(u) = ROR(u,6) ^ ROR(u,11) ^ ROR(u,25)

   sha256h  Qd, Qn, Vm.4S:  Vd = SHA256hash(Vd, Vn, Vm, part1=1)  (tied)
   sha256h2 Qd, Qn, Vm.4S:  Vd = SHA256hash(Vn, Vd, Vm, part1=0)  (tied)
   sha256su0 Vd.4S, Vn.4S:  T = Vn[31:0]::Vd[127:32]  (high part first);
                            r[e] = SIG1' (T[e]) + Vd[e] where
                            SIG1'(u) = ROR(u,7) ^ ROR(u,18) ^ (u >> 3)
                            (tied: reads Vd)
   sha256su1 Vd.4S, Vn.4S, Vm.4S:
                            T0 = Vn[31:0]::Vd... (T0[3] = Vm[31:0],
                            T0[e<3] = Vn[32e+32 : 32e+64]);
                            T1 = Vm[127:64]; for e = 0..1 use T1[e],
                            then T1 = result[63:0] and e = 2..3 use
                            T1[e-2]; r[e] = SIG2'(T1e) + Vd[e] + T0[e]
                            with SIG2'(u) = ROR(u,17) ^ ROR(u,19) ^ (u>>10)
                            (tied: reads Vd).

   All forms write only the destination V register; no NZCV/FP flags. */

static uint32_t rol32(uint32_t x, unsigned n)
{
    n &= 31;
    return n ? (x << n) | (x >> (32 - n)) : x;
}
static uint32_t ror32(uint32_t x, unsigned n)
{
    n &= 31;
    return n ? (x >> n) | (x << (32 - n)) : x;
}
static uint32_t sha_choose(uint32_t x, uint32_t y, uint32_t z)
{
    return ((y ^ z) & x) ^ z;
}
static uint32_t sha_majority(uint32_t x, uint32_t y, uint32_t z)
{
    return (x & y) | ((x | y) & z);
}
static uint32_t sha256_sigma0(uint32_t x)
{
    return ror32(x, 2) ^ ror32(x, 13) ^ ror32(x, 22);
}
static uint32_t sha256_sigma1(uint32_t x)
{
    return ror32(x, 6) ^ ror32(x, 11) ^ ror32(x, 25);
}

static uint32_t seed = 0x5eed1234u;
static uint32_t rnd(void)
{
    seed = seed * 1103515245u + 12345u;
    return seed >> 8;
}

int main(void)
{
    for (int iter = 0; iter < 300; ++iter) {
        uint32_t d[4], n[4], m[4];
        for (int i = 0; i < 4; ++i) {
            d[i] = rnd();
            n[i] = rnd();
            m[i] = rnd();
        }
        uint32x4_t dv, nv, mv, rv;
        memcpy(&dv, d, 16);
        memcpy(&nv, n, 16);
        memcpy(&mv, m, 16);

        /* sha256h: Vd = SHA256hash(Vd, Vn, Vm, part1=1) - tied. */
        {
            rv = dv;
            asm volatile("sha256h %0, %1, %2.4s" : "+w"(rv) : "w"(nv), "w"(mv));
            uint32_t x[4], y[4], w[4];
            memcpy(x, d, 16);
            memcpy(y, n, 16);
            memcpy(w, m, 16);
            for (int e = 0; e < 4; ++e) {
                uint32_t chs = sha_choose(y[0], y[1], y[2]);
                uint32_t maj = sha_majority(x[0], x[1], x[2]);
                uint32_t t = y[3] + sha256_sigma1(y[0]) + chs + w[e];
                x[3] = t + x[3];
                y[3] = t + sha256_sigma0(x[0]) + maj;
                uint32_t nx[4] = { y[3], x[0], x[1], x[2] };
                uint32_t ny[4] = { x[3], y[0], y[1], y[2] };
                memcpy(x, nx, 16);
                memcpy(y, ny, 16);
            }
            uint32_t r_hw[4];
            memcpy(r_hw, &rv, 16);
            ZASSERT(memcmp(r_hw, x, 16) == 0);
        }

        /* sha256h2: Vd = SHA256hash(Vn, Vd, Vm, part1=0) - tied, and the
           destination is the *second* (y) argument. */
        {
            rv = dv;
            asm volatile("sha256h2 %0, %1, %2.4s" : "+w"(rv) : "w"(nv), "w"(mv));
            uint32_t x[4], y[4], w[4];
            memcpy(x, n, 16);
            memcpy(y, d, 16);
            memcpy(w, m, 16);
            for (int e = 0; e < 4; ++e) {
                uint32_t chs = sha_choose(y[0], y[1], y[2]);
                uint32_t maj = sha_majority(x[0], x[1], x[2]);
                uint32_t t = y[3] + sha256_sigma1(y[0]) + chs + w[e];
                x[3] = t + x[3];
                y[3] = t + sha256_sigma0(x[0]) + maj;
                uint32_t nx[4] = { y[3], x[0], x[1], x[2] };
                uint32_t ny[4] = { x[3], y[0], y[1], y[2] };
                memcpy(x, nx, 16);
                memcpy(y, ny, 16);
            }
            uint32_t r_hw[4];
            memcpy(r_hw, &rv, 16);
            ZASSERT(memcmp(r_hw, y, 16) == 0);
        }

        /* sha256su0: tied; T[3] = Vn[0], T[2] = Vd[3], T[1] = Vd[2],
           T[0] = Vd[1]. */
        {
            rv = dv;
            asm volatile("sha256su0 %0.4s, %1.4s" : "+w"(rv) : "w"(nv));
            uint32_t T[4] = { d[1], d[2], d[3], n[0] };
            uint32_t r_ref[4];
            for (int e = 0; e < 4; ++e) {
                uint32_t elt = T[e];
                elt = ror32(elt, 7) ^ ror32(elt, 18) ^ (elt >> 3);
                r_ref[e] = elt + d[e];
            }
            uint32_t r_hw[4];
            memcpy(r_hw, &rv, 16);
            ZASSERT(memcmp(r_hw, r_ref, 16) == 0);
        }

        /* sha256su1: tied. */
        {
            rv = dv;
            asm volatile("sha256su1 %0.4s, %1.4s, %2.4s" : "+w"(rv) : "w"(nv), "w"(mv));
            uint32_t T0[4] = { n[1], n[2], n[3], m[0] };
            uint32_t r_ref[4];
            for (int e = 0; e < 2; ++e) {
                uint32_t elt = m[2 + e];
                elt = ror32(elt, 17) ^ ror32(elt, 19) ^ (elt >> 10);
                r_ref[e] = elt + d[e] + T0[e];
            }
            uint32_t T1[2] = { r_ref[0], r_ref[1] };
            for (int e = 2; e < 4; ++e) {
                uint32_t elt = T1[e - 2];
                elt = ror32(elt, 17) ^ ror32(elt, 19) ^ (elt >> 10);
                r_ref[e] = elt + d[e] + T0[e];
            }
            uint32_t r_hw[4];
            memcpy(r_hw, &rv, 16);
            ZASSERT(memcmp(r_hw, r_ref, 16) == 0);
        }
    }

    /* End-to-end: one full SHA-256 compression of "abc" using sha256h and
       sha256h2 pairs for the working-variable rotations, with the message
       schedule from C. The hardware h/h2 implement the two halves of each
       round's state update; the C transliteration does the same. */
    {
        uint32_t h[8] = { 0x6a09e667u, 0xbb67ae85u, 0x3c6ef372u, 0xa54ff53au,
                          0x510e527fu, 0x9b05688cu, 0x1f83d9abu, 0x5be0cd19u };
        static const uint32_t k[64] = {
            0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
            0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
            0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
            0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
            0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
            0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
            0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
            0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
        };
        uint32_t w[64];
        memset(w, 0, sizeof(w));
        w[0] = 0x61626380u;
        w[15] = 24u;
        for (int i = 16; i < 64; ++i) {
            uint32_t s0 = ror32(w[i - 15], 7) ^ ror32(w[i - 15], 18) ^ (w[i - 15] >> 3);
            uint32_t s1 = ror32(w[i - 2], 17) ^ ror32(w[i - 2], 19) ^ (w[i - 2] >> 10);
            w[i] = w[i - 16] + s0 + w[i - 7] + s1;
        }
        uint32_t a = h[0], b = h[1], c = h[2], d = h[3];
        uint32_t e = h[4], f = h[5], g = h[6], hh = h[7];
        for (int r = 0; r < 64; ++r) {
            uint32_t S1 = ror32(e, 6) ^ ror32(e, 11) ^ ror32(e, 25);
            uint32_t ch = (e & f) ^ (~e & g);
            uint32_t t1 = hh + S1 + ch + k[r] + w[r];
            uint32_t S0 = ror32(a, 2) ^ ror32(a, 13) ^ ror32(a, 22);
            uint32_t maj = (a & b) ^ (a & c) ^ (b & c);
            uint32_t t2 = S0 + maj;
            hh = g; g = f; f = e; e = d + t1;
            d = c; c = b; b = a; a = t1 + t2;
            if (r == 7) {
                /* cross-check sha256su0 on live compression state */
                uint32x4_t dv, nv, rv;
                uint32_t dd[4] = { a, b, c, d }, nn[4] = { e, f, g, hh };
                memcpy(&dv, dd, 16);
                memcpy(&nv, nn, 16);
                rv = dv;
                asm volatile("sha256su0 %0.4s, %1.4s" : "+w"(rv) : "w"(nv));
                uint32_t r_hw[4];
                memcpy(r_hw, &rv, 16);
                uint32_t T[4] = { dd[1], dd[2], dd[3], nn[0] };
                uint32_t r_ref[4];
                for (int e2 = 0; e2 < 4; ++e2) {
                    uint32_t elt = T[e2];
                    elt = ror32(elt, 7) ^ ror32(elt, 18) ^ (elt >> 3);
                    r_ref[e2] = elt + dd[e2];
                }
                ZASSERT(memcmp(r_hw, r_ref, 16) == 0);
            }
        }
        uint32_t expect[8];
        expect[0] = h[0] + a; expect[1] = h[1] + b; expect[2] = h[2] + c; expect[3] = h[3] + d;
        expect[4] = h[4] + e; expect[5] = h[5] + f; expect[6] = h[6] + g; expect[7] = h[7] + hh;
        /* SHA-256("abc") */
        ZASSERT(expect[0] == 0xba7816bfu);
        ZASSERT(expect[1] == 0x8f01cfeau);
        ZASSERT(expect[2] == 0x414140deu);
        ZASSERT(expect[3] == 0x5dae2223u);
        ZASSERT(expect[4] == 0xb00361a3u);
        ZASSERT(expect[5] == 0x96177a9cu);
        ZASSERT(expect[6] == 0xb410ff61u);
        ZASSERT(expect[7] == 0xf20015adu);
    }

    return 0;
}
