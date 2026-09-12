#include <stdfil.h>
#include <stdint.h>

/* FEAT_CRC32 CRC-32 checksum instructions: crc32b/h/w/x use the CRC-32
   polynomial 0x04C11DB7, crc32cb/ch/cw/cx use the Castagnoli polynomial
   0x1EDC6F41. Written as three-operand forms: Wd = f(Wn, Wm/Xm).

   This is a direct transliteration of the ISA pseudocode (crc32.xml /
   crc32c.xml):

       acc  = X[n][31:0]
       val  = X[m][size-1:0]
       poly = 0x04C11DB7[31:0]  (or 0x1EDC6F41 for crc32c)
       tempacc = BitReverse{32}(acc)::Zeros{size}
       tempval = BitReverse{size}(val)::Zeros{32}
       X[d][31:0] = BitReverse{32}(Poly32Mod2(tempacc XOR tempval, poly))

   Poly32Mod2{N}(data, poly):
       for i = N-1 downto 32:
           if data[i]:
               data[i-1:0] ^= poly::Zeros{i-32}   // poly[31-j] at data[i-1-j]
       return data[31:0]
   BitReverse{N}(x)[i] = x[N-1-i].

   (Cross-checked against the hardware: the result also equals the standard
   reflected byte-wise CRC-32 update of the little-endian bytes of val.) */

static uint32_t crc32_ref_poly(uint32_t acc, uint64_t val, int size, uint32_t poly)
{
    int N = 32 + size;
    unsigned char tempacc[128] = {0}, tempval[128] = {0}, data[128];
    /* tempacc = BitReverse{32}(acc)::Zeros{size} */
    for (int i = 0; i < 32; ++i)
        tempacc[size + i] = (unsigned char)((acc >> (31 - i)) & 1u);
    /* tempval = BitReverse{size}(val)::Zeros{32} */
    for (int i = 0; i < size; ++i)
        tempval[32 + i] = (unsigned char)((val >> (size - 1 - i)) & 1u);
    for (int i = 0; i < N; ++i)
        data[i] = (unsigned char)(tempacc[i] ^ tempval[i]);
    /* Poly32Mod2{N}(data, poly) */
    for (int i = N - 1; i >= 32; --i) {
        if (data[i]) {
            for (int j = 0; j < 32; ++j)
                data[i - 1 - j] ^= (unsigned char)((poly >> (31 - j)) & 1u);
        }
    }
    /* X[d] = BitReverse{32}(result) */
    uint32_t out = 0;
    for (int i = 0; i < 32; ++i)
        out |= (uint32_t)data[31 - i] << i;
    return out;
}

static uint32_t crc32_ref(uint32_t acc, uint64_t val, int size)
{
    return crc32_ref_poly(acc, val, size, 0x04C11DB7u);
}

static uint32_t crc32c_ref(uint32_t acc, uint64_t val, int size)
{
    return crc32_ref_poly(acc, val, size, 0x1EDC6F41u);
}

static uint32_t seed = 0x9e3779b9u;
static uint32_t rnd(void)
{
    seed = seed * 1103515245u + 12345u;
    return seed >> 8;
}

int main(void)
{
    /* Fixed spot checks first. */
    uint32_t acc = 0x47bf7191u;
    uint64_t val = 0x002e1d6a00999462ull;
    uint32_t r;

    asm volatile("crc32b %w0, %w1, %w2" : "=r"(r) : "r"(acc), "r"(val));
    ZASSERT(r == crc32_ref(acc, val, 8));
    ZASSERT(r == 0x24f31cd7u);

    asm volatile("crc32h %w0, %w1, %w2" : "=r"(r) : "r"(acc), "r"(val));
    ZASSERT(r == crc32_ref(acc, val, 16));

    asm volatile("crc32w %w0, %w1, %w2" : "=r"(r) : "r"(acc), "r"(val));
    ZASSERT(r == crc32_ref(acc, val, 32));

    asm volatile("crc32x %w0, %w1, %2" : "=r"(r) : "r"(acc), "r"(val));
    ZASSERT(r == crc32_ref(acc, val, 64));

    asm volatile("crc32cb %w0, %w1, %w2" : "=r"(r) : "r"(acc), "r"(val));
    ZASSERT(r == crc32c_ref(acc, val, 8));
    ZASSERT(r == 0xe07923f0u);

    asm volatile("crc32ch %w0, %w1, %w2" : "=r"(r) : "r"(acc), "r"(val));
    ZASSERT(r == crc32c_ref(acc, val, 16));

    asm volatile("crc32cw %w0, %w1, %w2" : "=r"(r) : "r"(acc), "r"(val));
    ZASSERT(r == crc32c_ref(acc, val, 32));

    asm volatile("crc32cx %w0, %w1, %2" : "=r"(r) : "r"(acc), "r"(val));
    ZASSERT(r == crc32c_ref(acc, val, 64));

    /* Randomized sweep over all eight forms, including chained
       accumulation (each result feeds the next accumulator). */
    uint32_t chain = 0xffffffffu;
    uint64_t v64 = 0x0123456789abcdefull;
    for (int iter = 0; iter < 500; ++iter) {
        acc = rnd() | (rnd() << 16);
        val = (uint64_t)rnd() << 32 | rnd();

        uint32_t rb, rh, rw, rx, rcb, rch, rcw, rcx;
        asm volatile("crc32b %w0, %w1, %w2" : "=r"(rb) : "r"(acc), "r"(val));
        asm volatile("crc32h %w0, %w1, %w2" : "=r"(rh) : "r"(acc), "r"(val));
        asm volatile("crc32w %w0, %w1, %w2" : "=r"(rw) : "r"(acc), "r"(val));
        asm volatile("crc32x %w0, %w1, %2" : "=r"(rx) : "r"(acc), "r"(val));
        asm volatile("crc32cb %w0, %w1, %w2" : "=r"(rcb) : "r"(acc), "r"(val));
        asm volatile("crc32ch %w0, %w1, %w2" : "=r"(rch) : "r"(acc), "r"(val));
        asm volatile("crc32cw %w0, %w1, %w2" : "=r"(rcw) : "r"(acc), "r"(val));
        asm volatile("crc32cx %w0, %w1, %2" : "=r"(rcx) : "r"(acc), "r"(val));
        ZASSERT(rb == crc32_ref(acc, val, 8));
        ZASSERT(rh == crc32_ref(acc, val, 16));
        ZASSERT(rw == crc32_ref(acc, val, 32));
        ZASSERT(rx == crc32_ref(acc, val, 64));
        ZASSERT(rcb == crc32c_ref(acc, val, 8));
        ZASSERT(rch == crc32c_ref(acc, val, 16));
        ZASSERT(rcw == crc32c_ref(acc, val, 32));
        ZASSERT(rcx == crc32c_ref(acc, val, 64));

        /* Tied-accumulator form: crc32b %w0, %w0, %w1 chains like the
           byte-wise CRC-32 loop. */
        uint32_t tied = acc;
        uint32_t byte = (uint32_t)((unsigned char)iter);
        asm volatile("crc32b %w0, %w0, %w1" : "+r"(tied) : "r"(byte));
        ZASSERT(tied == crc32_ref(acc, byte, 8));
        chain = tied;
        uint32_t rcx2;
        asm volatile("crc32cx %w0, %w1, %2" : "=r"(rcx2) : "r"(chain), "r"(v64));
        ZASSERT(rcx2 == crc32c_ref(chain, v64, 64));
    }

    /* Byte-wise chain of all 8 bytes of a 64-bit value equals crc32x of
       the whole value (documented equivalence of the reflected forms). */
    acc = rnd();
    uint64_t big = (uint64_t)rnd() << 32 | rnd();
    uint32_t acc0 = acc;
    for (int i = 0; i < 8; ++i) {
        uint32_t byte = (uint32_t)((big >> (8 * i)) & 0xff);
        asm volatile("crc32b %w0, %w0, %w1" : "+r"(acc) : "r"(byte));
    }
    ZASSERT(acc == crc32_ref(acc0, big, 64));

    return 0;
}
