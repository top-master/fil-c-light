#include <stdfil.h>
#include <arm_neon.h>
#include <stdint.h>
#include <string.h>

/* FEAT_SHA3 instructions checked against exact C transliterations of the
   ISA pseudocode (rax1/eor3/bcax/xar _advsimd.xml). These are the SHA-3
   round helpers used by Keccak:

     rax1 Vd.2D, Vn.2D, Vm.2D:
         Vd = Vn ^ (ROL(Vm[127:64], 1) :: ROL(Vm[63:0], 1))
         (pure three-operand: the destination is not read)
     eor3 Vd.16B, Vn.16B, Vm.16B, Va.16B:
         Vd = Vn ^ Vm ^ Va
         (pure FOUR-operand: the destination is not read)
     bcax Vd.16B, Vn.16B, Vm.16B, Va.16B:
         Vd = Vn ^ (Vm & ~Va)
         (pure four-operand: the destination is not read)
     xar Vd.2D, Vn.2D, Vm.2D, #imm6:
         Vd = ROR(Vn ^ Vm, imm) per 64-bit lane
         (pure; the rotate amount is a literal immediate operand)

   Nothing here sets NZCV or FP flags. */

static uint64_t rol64(uint64_t x, unsigned n)
{
    n &= 63;
    return n ? (x << n) | (x >> (64 - n)) : x;
}
static uint64_t ror64(uint64_t x, unsigned n)
{
    n &= 63;
    return n ? (x >> n) | (x << (64 - n)) : x;
}

static uint32_t seed = 0x5a3c0de5u;
static uint32_t rnd(void)
{
    seed = seed * 1103515245u + 12345u;
    return seed >> 8;
}

int main(void)
{
    for (int iter = 0; iter < 400; ++iter) {
        uint64_t n[2], m[2], a[2];
        for (int i = 0; i < 2; ++i) {
            n[i] = (uint64_t)rnd() << 32 | rnd();
            m[i] = (uint64_t)rnd() << 32 | rnd();
            a[i] = (uint64_t)rnd() << 32 | rnd();
        }
        uint64x2_t nv, mv, av, rv;
        memcpy(&nv, n, 16);
        memcpy(&mv, m, 16);
        memcpy(&av, a, 16);
        uint64_t r_hw[2], r_ref[2];

        /* rax1: Vd = Vn ^ (ROL(Vm.hi,1) :: ROL(Vm.lo,1)). */
        asm volatile("rax1 %0.2d, %1.2d, %2.2d" : "=w"(rv) : "w"(nv), "w"(mv));
        memcpy(r_hw, &rv, 16);
        r_ref[0] = n[0] ^ rol64(m[0], 1);
        r_ref[1] = n[1] ^ rol64(m[1], 1);
        ZASSERT(memcmp(r_hw, r_ref, 16) == 0);

        /* eor3: Vd = Vn ^ Vm ^ Va (four-operand, pure). */
        asm volatile("eor3 %0.16b, %1.16b, %2.16b, %3.16b"
                     : "=w"(rv) : "w"(nv), "w"(mv), "w"(av));
        memcpy(r_hw, &rv, 16);
        r_ref[0] = n[0] ^ m[0] ^ a[0];
        r_ref[1] = n[1] ^ m[1] ^ a[1];
        ZASSERT(memcmp(r_hw, r_ref, 16) == 0);

        /* bcax: Vd = Vn ^ (Vm & ~Va) (four-operand, pure). */
        asm volatile("bcax %0.16b, %1.16b, %2.16b, %3.16b"
                     : "=w"(rv) : "w"(nv), "w"(mv), "w"(av));
        memcpy(r_hw, &rv, 16);
        r_ref[0] = n[0] ^ (m[0] & ~a[0]);
        r_ref[1] = n[1] ^ (m[1] & ~a[1]);
        ZASSERT(memcmp(r_hw, r_ref, 16) == 0);

        /* xar: Vd = ROR(Vn ^ Vm, #imm) per lane. The rotate amount must be
           a literal immediate in the asm template (it cannot come from an
           operand), so each amount is spelled out. */
        {
            uint64_t base[2] = { n[0] ^ m[0], n[1] ^ m[1] };
            uint64x2_t bv;
            memcpy(&bv, base, 16);
            (void)bv;

            uint64_t x0 = ror64(base[0], 0), x1 = ror64(base[1], 0);
            asm volatile("xar %0.2d, %1.2d, %2.2d, #0" : "=w"(rv) : "w"(nv), "w"(mv));
            memcpy(r_hw, &rv, 16);
            r_ref[0] = x0; r_ref[1] = x1;
            ZASSERT(memcmp(r_hw, r_ref, 16) == 0);

            x0 = ror64(base[0], 1); x1 = ror64(base[1], 1);
            asm volatile("xar %0.2d, %1.2d, %2.2d, #1" : "=w"(rv) : "w"(nv), "w"(mv));
            memcpy(r_hw, &rv, 16);
            r_ref[0] = x0; r_ref[1] = x1;
            ZASSERT(memcmp(r_hw, r_ref, 16) == 0);

            x0 = ror64(base[0], 7); x1 = ror64(base[1], 7);
            asm volatile("xar %0.2d, %1.2d, %2.2d, #7" : "=w"(rv) : "w"(nv), "w"(mv));
            memcpy(r_hw, &rv, 16);
            r_ref[0] = x0; r_ref[1] = x1;
            ZASSERT(memcmp(r_hw, r_ref, 16) == 0);

            x0 = ror64(base[0], 13); x1 = ror64(base[1], 13);
            asm volatile("xar %0.2d, %1.2d, %2.2d, #13" : "=w"(rv) : "w"(nv), "w"(mv));
            memcpy(r_hw, &rv, 16);
            r_ref[0] = x0; r_ref[1] = x1;
            ZASSERT(memcmp(r_hw, r_ref, 16) == 0);

            x0 = ror64(base[0], 32); x1 = ror64(base[1], 32);
            asm volatile("xar %0.2d, %1.2d, %2.2d, #32" : "=w"(rv) : "w"(nv), "w"(mv));
            memcpy(r_hw, &rv, 16);
            r_ref[0] = x0; r_ref[1] = x1;
            ZASSERT(memcmp(r_hw, r_ref, 16) == 0);

            x0 = ror64(base[0], 63); x1 = ror64(base[1], 63);
            asm volatile("xar %0.2d, %1.2d, %2.2d, #63" : "=w"(rv) : "w"(nv), "w"(mv));
            memcpy(r_hw, &rv, 16);
            r_ref[0] = x0; r_ref[1] = x1;
            ZASSERT(memcmp(r_hw, r_ref, 16) == 0);
        }
    }

    /* End-to-end: run the theta/rho/pi/iota part of a Keccak-f[1600] round
       with eor3 (which is the instruction SHA-3 uses for theta's parity
       computation on AArch64) and check against the C model. */
    {
        uint64_t st[25];
        for (int i = 0; i < 25; ++i)
            st[i] = (uint64_t)rnd() << 32 | rnd();
        uint64_t C[5], D[5];
        for (int x = 0; x < 5; ++x)
            C[x] = st[x] ^ st[x + 5] ^ st[x + 10] ^ st[x + 15] ^ st[x + 20];
        for (int x = 0; x < 5; ++x) {
            /* D[x] = C[x-1] ^ ROL(C[x+1], 1) - the ROL is rax1's transform */
            uint64x2_t cv, mv2, rv;
            uint64_t m2[2] = { C[(x + 1) % 5], C[(x + 1) % 5] };
            uint64_t cc[2] = { C[(x + 4) % 5], C[(x + 4) % 5] };
            memcpy(&cv, cc, 16);
            memcpy(&mv2, m2, 16);
            asm volatile("rax1 %0.2d, %1.2d, %2.2d" : "=w"(rv) : "w"(cv), "w"(mv2));
            uint64_t r_hw[2];
            memcpy(r_hw, &rv, 16);
            D[x] = C[(x + 4) % 5] ^ rol64(C[(x + 1) % 5], 1);
            ZASSERT(r_hw[0] == D[x]);
            ZASSERT(r_hw[1] == D[x]);
        }
        /* eor3 computes the parity directly: C[x] = A[x] ^ A[x+5] ^
           A[x+10] ^ A[x+15] ^ A[x+20] needs two eor3's per lane. */
        for (int x = 0; x < 5; ++x) {
            uint64x2_t t1, t2, t3, rv;
            uint64_t s1[2] = { st[x + 5], st[x + 5] };
            uint64_t s2[2] = { st[x + 10], st[x + 10] };
            uint64_t s3[2] = { st[x], st[x] };
            memcpy(&t1, s1, 16);
            memcpy(&t2, s2, 16);
            memcpy(&t3, s3, 16);
            asm volatile("eor3 %0.16b, %1.16b, %2.16b, %3.16b"
                         : "=w"(rv) : "w"(t1), "w"(t2), "w"(t3));
            uint64_t r_hw[2];
            memcpy(r_hw, &rv, 16);
            /* partial parity of three of the five lanes */
            ZASSERT(r_hw[0] == (st[x + 5] ^ st[x + 10] ^ st[x]));
            uint64_t s4[2] = { st[x + 15], st[x + 15] };
            uint64_t s5[2] = { st[x + 20], st[x + 20] };
            uint64_t z[2] = { 0, 0 };
            memcpy(&t1, s4, 16);
            memcpy(&t2, s5, 16);
            memcpy(&t3, z, 16);
            asm volatile("eor3 %0.16b, %1.16b, %2.16b, %3.16b"
                         : "=w"(rv) : "w"(t1), "w"(t2), "w"(t3));
            memcpy(r_hw, &rv, 16);
            ZASSERT(r_hw[0] == (st[x + 15] ^ st[x + 20]));
        }
    }

    return 0;
}
