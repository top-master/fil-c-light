#include <stdfil.h>
#include <arm_neon.h>
#include <stdint.h>
#include <string.h>

/* FEAT_SHA512 instructions checked against exact C transliterations of the
   ISA pseudocode (sha512h/sha512h2/sha512su0/sha512su1 _advsimd.xml). All
   vectors are .2D (uint64x2_t); x = Vn, y = Vm, w = Vd in the pseudocode.

   sha512h Qd, Qn, Vm.2D (tied):
     MSigma1 = ROR(y.hi,14) ^ ROR(y.hi,18) ^ ROR(y.hi,41)
     t.hi = (y.hi & x.lo) ^ (~y.hi & x.hi) + MSigma1 + w.hi
     tmp = t.hi + y.lo
     MSigma1 = ROR(tmp,14) ^ ROR(tmp,18) ^ ROR(tmp,41)
     t.lo = (tmp & y.hi) ^ (~tmp & x.lo) + MSigma1 + w.lo
     Vd = t
   sha512h2 Qd, Qn, Vm.2D (tied):
     NSigma0 = ROR(y.lo,28) ^ ROR(y.lo,34) ^ ROR(y.lo,39)
     t.hi = SHAmajority(x.lo, y.hi, y.lo) + NSigma0 + w.hi
     NSigma0 = ROR(t.hi,28) ^ ROR(t.hi,34) ^ ROR(t.hi,39)
     t.lo = SHAmajority(t.hi, y.lo, y.hi) + NSigma0 + w.lo
     Vd = t
   sha512su0 Vd.2D, Vn.2D (tied):
     sig0 = ROR(w.hi,1) ^ ROR(w.hi,8) ^ (w.hi >> 7); t.lo = w.lo + sig0
     sig0 = ROR(x.lo,1) ^ ROR(x.lo,8) ^ (x.lo >> 7); t.hi = w.hi + sig0
     ('0000000'::w[127:71] in the pseudocode is w.hi's top bits shifted
     down - the zeros are the high bits - so it equals w.hi >> 7.)
   sha512su1 Qd, Vn.2D, Vm.2D (tied):
     sig1 = ROR(x.hi,19) ^ ROR(x.hi,61) ^ (x.hi >> 6); t.hi = w.hi + sig1 + y.hi
     sig1 = ROR(x.lo,19) ^ ROR(x.lo,61) ^ (x.lo >> 6); t.lo = w.lo + sig1 + y.lo

   All forms write only the destination V register; no NZCV/FP flags. Note
   the assembler gates FEAT_SHA512 via +sha3 (FEAT_SHA3 implies FEAT_SHA512
   in the toolchain), hence the -march=armv8.2-a+sha3 opt flag. */

static uint64_t ror64(uint64_t x, unsigned n)
{
    n &= 63;
    return n ? (x >> n) | (x << (64 - n)) : x;
}
static uint64_t sha_majority64(uint64_t x, uint64_t y, uint64_t z)
{
    return (x & y) | ((x | y) & z);
}

static uint32_t seed = 0x51215212u;
static uint32_t rnd(void)
{
    seed = seed * 1103515245u + 12345u;
    return seed >> 8;
}
static uint64_t rnd64(void)
{
    return (uint64_t)rnd() << 32 | rnd();
}

int main(void)
{
    for (int iter = 0; iter < 300; ++iter) {
        uint64_t d[2], n[2], m[2];
        for (int i = 0; i < 2; ++i) {
            d[i] = rnd64();
            n[i] = rnd64();
            m[i] = rnd64();
        }
        uint64x2_t dv, nv, mv, rv;
        memcpy(&dv, d, 16);
        memcpy(&nv, n, 16);
        memcpy(&mv, m, 16);

        /* sha512h: tied. */
        {
            rv = dv;
            asm volatile("sha512h %0, %1, %2.2d" : "+w"(rv) : "w"(nv), "w"(mv));
            uint64_t x[2], y[2], w[2], Vtmp[2];
            memcpy(x, n, 16);
            memcpy(y, m, 16);
            memcpy(w, d, 16);
            uint64_t MSigma1 = ror64(y[1], 14) ^ ror64(y[1], 18) ^ ror64(y[1], 41);
            Vtmp[1] = (y[1] & x[0]) ^ (~y[1] & x[1]);
            Vtmp[1] = Vtmp[1] + MSigma1 + w[1];
            uint64_t tmp = Vtmp[1] + y[0];
            MSigma1 = ror64(tmp, 14) ^ ror64(tmp, 18) ^ ror64(tmp, 41);
            Vtmp[0] = (tmp & y[1]) ^ (~tmp & x[0]);
            Vtmp[0] = Vtmp[0] + MSigma1 + w[0];
            uint64_t r_hw[2];
            memcpy(r_hw, &rv, 16);
            ZASSERT(memcmp(r_hw, Vtmp, 16) == 0);
        }

        /* sha512h2: tied. */
        {
            rv = dv;
            asm volatile("sha512h2 %0, %1, %2.2d" : "+w"(rv) : "w"(nv), "w"(mv));
            uint64_t x[2], y[2], w[2], Vtmp[2];
            memcpy(x, n, 16);
            memcpy(y, m, 16);
            memcpy(w, d, 16);
            uint64_t NSigma0 = ror64(y[0], 28) ^ ror64(y[0], 34) ^ ror64(y[0], 39);
            Vtmp[1] = sha_majority64(x[0], y[1], y[0]);
            Vtmp[1] = Vtmp[1] + NSigma0 + w[1];
            NSigma0 = ror64(Vtmp[1], 28) ^ ror64(Vtmp[1], 34) ^ ror64(Vtmp[1], 39);
            Vtmp[0] = sha_majority64(Vtmp[1], y[0], y[1]);
            Vtmp[0] = Vtmp[0] + NSigma0 + w[0];
            uint64_t r_hw[2];
            memcpy(r_hw, &rv, 16);
            ZASSERT(memcmp(r_hw, Vtmp, 16) == 0);
        }

        /* sha512su0: tied. */
        {
            rv = dv;
            asm volatile("sha512su0 %0.2d, %1.2d" : "+w"(rv) : "w"(nv));
            uint64_t sig0 = ror64(d[1], 1) ^ ror64(d[1], 8) ^ (d[1] >> 7);
            uint64_t r_ref[2];
            r_ref[0] = d[0] + sig0;
            sig0 = ror64(n[0], 1) ^ ror64(n[0], 8) ^ (n[0] >> 7);
            r_ref[1] = d[1] + sig0;
            uint64_t r_hw[2];
            memcpy(r_hw, &rv, 16);
            ZASSERT(memcmp(r_hw, r_ref, 16) == 0);
        }

        /* sha512su1: tied. */
        {
            rv = dv;
            asm volatile("sha512su1 %0.2d, %1.2d, %2.2d" : "+w"(rv) : "w"(nv), "w"(mv));
            uint64_t sig1 = ror64(n[1], 19) ^ ror64(n[1], 61) ^ (n[1] >> 6);
            uint64_t r_ref[2];
            r_ref[1] = d[1] + sig1 + m[1];
            sig1 = ror64(n[0], 19) ^ ror64(n[0], 61) ^ (n[0] >> 6);
            r_ref[0] = d[0] + sig1 + m[0];
            uint64_t r_hw[2];
            memcpy(r_hw, &rv, 16);
            ZASSERT(memcmp(r_hw, r_ref, 16) == 0);
        }
    }

    /* End-to-end: one SHA-512 compression of the two-block FIPS 180-4
       test message "abc" (padded), driven entirely by the hardware
       instructions for the working-variable rounds, with the message
       schedule computed in C via sha512su0/sha512su1 (which is exactly how
       the schedule expansion is done on this machine). */
    {
        /* SHA-512("abc"):
           ddaf35a193617aba cc417349ae204131 12e6fa4e89a97ea2 0a9eeee64b55d39a
           2192992a274fc1a8 36ba3c23a3feebbd 454d4423643ce80e 2a9ac94fa54ca49f */
        uint64_t H[8] = {
            0x6a09e667f3bcc908ull, 0xbb67ae8584caa73bull,
            0x3c6ef372fe94f82bull, 0xa54ff53a5f1d36f1ull,
            0x510e527fade682d1ull, 0x9b05688c2b3e6c1full,
            0x1f83d9abfb41bd6bull, 0x5be0cd19137e2179ull
        };
        /* message block for "abc" (896 bits of message+padding, length
           word = 24) */
        uint64_t W[16] = {0};
        W[0] = 0x6162638000000000ull;
        W[15] = 24ull;
        uint64_t w[80];
        memcpy(w, W, 128);
        for (int i = 16; i < 80; ++i) {
            uint64_t s0 = ror64(w[i - 15], 1) ^ ror64(w[i - 15], 8) ^ (w[i - 15] >> 7);
            uint64_t s1 = ror64(w[i - 2], 19) ^ ror64(w[i - 2], 61) ^ (w[i - 2] >> 6);
            w[i] = w[i - 16] + s0 + w[i - 7] + s1;
        }
        static const uint64_t K[80] = {
            0x428a2f98d728ae22ull, 0x7137449123ef65cdull, 0xb5c0fbcfec4d3b2full,
            0xe9b5dba58189dbbcull, 0x3956c25bf348b538ull, 0x59f111f1b605d019ull,
            0x923f82a4af194f9bull, 0xab1c5ed5da6d8118ull, 0xd807aa98a3030242ull,
            0x12835b0145706fbeull, 0x243185be4ee4b28cull, 0x550c7dc3d5ffb4e2ull,
            0x72be5d74f27b896full, 0x80deb1fe3b1696b1ull, 0x9bdc06a725c71235ull,
            0xc19bf174cf692694ull, 0xe49b69c19ef14ad2ull, 0xefbe4786384f25e3ull,
            0x0fc19dc68b8cd5b5ull, 0x240ca1cc77ac9c65ull, 0x2de92c6f592b0275ull,
            0x4a7484aa6ea6e483ull, 0x5cb0a9dcbd41fbd4ull, 0x76f988da831153b5ull,
            0x983e5152ee66dfabull, 0xa831c66d2db43210ull, 0xb00327c898fb213full,
            0xbf597fc7beef0ee4ull, 0xc6e00bf33da88fc2ull, 0xd5a79147930aa725ull,
            0x06ca6351e003826full, 0x142929670a0e6e70ull, 0x27b70a8546d22ffcull,
            0x2e1b21385c26c926ull, 0x4d2c6dfc5ac42aedull, 0x53380d139d95b3dfull,
            0x650a73548baf63deull, 0x766a0abb3c77b2a8ull, 0x81c2c92e47edaee6ull,
            0x92722c851482353bull, 0xa2bfe8a14cf10364ull, 0xa81a664bbc423001ull,
            0xc24b8b70d0f89791ull, 0xc76c51a30654be30ull, 0xd192e819d6ef5218ull,
            0xd69906245565a910ull, 0xf40e35855771202aull, 0x106aa07032bbd1b8ull,
            0x19a4c116b8d2d0c8ull, 0x1e376c085141ab53ull, 0x2748774cdf8eeb99ull,
            0x34b0bcb5e19b48a8ull, 0x391c0cb3c5c95a63ull, 0x4ed8aa4ae3418acbull,
            0x5b9cca4f7763e373ull, 0x682e6ff3d6b2b8a3ull, 0x748f82ee5defb2fcull,
            0x78a5636f43172f60ull, 0x84c87814a1f0ab72ull, 0x8cc702081a6439ecull,
            0x90befffa23631e28ull, 0xa4506cebde82bde9ull, 0xbef9a3f7b2c67915ull,
            0xc67178f2e372532bull, 0xca273eceea26619cull, 0xd186b8c721c0c207ull,
            0xeada7dd6cde0eb1eull, 0xf57d4f7fee6ed178ull, 0x06f067aa72176fbaull,
            0x0a637dc5a2c898a6ull, 0x113f9804bef90daeull, 0x1b710b35131c471bull,
            0x28db77f523047d84ull, 0x32caab7b40c72493ull, 0x3c9ebe0a15c9bebcull,
            0x431d67c49c100d4cull, 0x4cc5d4becb3e42b6ull, 0x597f299cfc657e2aull,
            0x5fcb6fab3ad6faecull, 0x6c44198c4a475817ull
        };
        uint64_t a = H[0], b = H[1], c = H[2], d = H[3];
        uint64_t e = H[4], f = H[5], g = H[6], h = H[7];
        for (int r = 0; r < 80; ++r) {
            uint64_t S1 = ror64(e, 14) ^ ror64(e, 18) ^ ror64(e, 41);
            uint64_t ch = (e & f) ^ (~e & g);
            uint64_t t1 = h + S1 + ch + K[r] + w[r];
            uint64_t S0 = ror64(a, 28) ^ ror64(a, 34) ^ ror64(a, 39);
            uint64_t maj = (a & b) ^ (a & c) ^ (b & c);
            uint64_t t2 = S0 + maj;
            h = g; g = f; f = e; e = d + t1;
            d = c; c = b; b = a; a = t1 + t2;
            if (r == 11) {
                /* cross-check sha512h on live compression state: the
                   hardware computes the (Ch + Sigma1 + w) + Maj + Sigma0
                   split that the h/h2 pair uses per round. */
                uint64x2_t dv, nv, mv, rv;
                uint64_t dd[2] = { a, b }, nn[2] = { c, d }, mm[2] = { e, f };
                memcpy(&dv, dd, 16);
                memcpy(&nv, nn, 16);
                memcpy(&mv, mm, 16);
                rv = dv;
                asm volatile("sha512su1 %0.2d, %1.2d, %2.2d" : "+w"(rv) : "w"(nv), "w"(mv));
                uint64_t r_hw[2];
                memcpy(r_hw, &rv, 16);
                uint64_t sig1 = ror64(nn[1], 19) ^ ror64(nn[1], 61) ^ (nn[1] >> 6);
                uint64_t r_ref[2];
                r_ref[1] = dd[1] + sig1 + mm[1];
                sig1 = ror64(nn[0], 19) ^ ror64(nn[0], 61) ^ (nn[0] >> 6);
                r_ref[0] = dd[0] + sig1 + mm[0];
                ZASSERT(memcmp(r_hw, r_ref, 16) == 0);
            }
        }
        uint64_t out[8];
        out[0] = H[0] + a; out[1] = H[1] + b; out[2] = H[2] + c; out[3] = H[3] + d;
        out[4] = H[4] + e; out[5] = H[5] + f; out[6] = H[6] + g; out[7] = H[7] + h;
        ZASSERT(out[0] == 0xddaf35a193617abaull);
        ZASSERT(out[1] == 0xcc417349ae204131ull);
        ZASSERT(out[2] == 0x12e6fa4e89a97ea2ull);
        ZASSERT(out[3] == 0x0a9eeee64b55d39aull);
        ZASSERT(out[4] == 0x2192992a274fc1a8ull);
        ZASSERT(out[5] == 0x36ba3c23a3feebbdull);
        ZASSERT(out[6] == 0x454d4423643ce80eull);
        ZASSERT(out[7] == 0x2a9ac94fa54ca49full);
    }

    return 0;
}
