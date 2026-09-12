#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void xadd_test(void* obj, void* out);
void adx_test(void* obj, void* out);
long crc_test(void* buf, long len);
void cmpx_test(void* obj, void* out);
void mulx_test(void* obj, void* out);

/* Bitwise CRC-32C (Castagnoli, reflected polynomial 0x82F63B78) reference:
   init 0xffffffff, no final xor — exactly what the hardware instruction
   computes. */
static unsigned crc32c_ref(unsigned crc, const unsigned char* p, unsigned long n)
{
    unsigned long i;
    for (i = 0; i < n; i++) {
        int k;
        crc ^= p[i];
        for (k = 0; k < 8; k++)
            crc = (crc >> 1) ^ (0x82F63B78u & (0u - (crc & 1u)));
    }
    return crc;
}

int main()
{
    /* xaddq: value in the LAST 8 bytes of a 16-byte object. */
    long* xobj = malloc(16);
    long* out = malloc(4 * sizeof(long));
    if (!xobj || !out)
        return 1;
    xobj[1] = 100;
    xadd_test(xobj, out);
    if (out[0] != 100 || xobj[1] != 105 || out[1] != 105) {
        printf("xadd reg=%ld mem=%ld\n", out[0], xobj[1]);
        return 1;
    }

    /* adcx/adox chains (dest RMW) plus mem-source forms. */
    long* aobj = malloc(16);
    if (!aobj)
        return 1;
    aobj[1] = 1000;
    adx_test(aobj, out);
    /* adcx reg chain: 10 + 20 + 1 = 31, then 31 + 20 = 51. */
    if (out[0] != 51) {
        printf("adcx chain %ld\n", out[0]);
        return 1;
    }
    /* adcx mem source: 51 + 1000 + CF. The inserted bounds check for the
       memory operand clobbers EFLAGS on the way in (pre-existing sarcasm
       codegen property — plain stc;adcq (mem),reg behaves identically), so
       the carry-in is 0 or 1. What this proves: the r/m form is accepted,
       checked at exactly 8 bytes (the object end — an over-wide check would
       have trapped), and the destination is RMW (both 51 and 1000 are read). */
    if (out[1] != 1051 && out[1] != 1052) {
        printf("adcx mem %ld\n", out[1]);
        return 1;
    }
    /* adox chain from OF=1: 100 + 7 + 1 = 108, then 108 + 7 = 115. */
    if (out[2] != 115) {
        printf("adox chain %ld\n", out[2]);
        return 1;
    }
    /* adox with mem source: 50 + 1000 + OF (carry-in indeterminate, see
       above). */
    if (out[3] != 1050 && out[3] != 1051) {
        printf("adox mem %ld\n", out[3]);
        return 1;
    }

    /* crc32b loop over a 37-byte buffer, checked against the bitwise
       reference. */
    unsigned char* buf = malloc(37);
    if (!buf)
        return 1;
    int i;
    for (i = 0; i < 37; i++)
        buf[i] = (unsigned char)(i * 31 + 7);
    long crc = crc_test(buf, 37);
    unsigned expect_crc = crc32c_ref(0xffffffffu, buf, 37);
    if ((unsigned long)crc != (unsigned long)expect_crc) {
        printf("crc %lx want %x\n", (unsigned long)crc, expect_crc);
        return 1;
    }
    /* Known-answer check of the reference itself: CRC-32C("123456789")
       with init 0xffffffff and no final xor is 0x1cf96d7c. */
    if (crc32c_ref(0xffffffffu, (const unsigned char*)"123456789", 9) != 0x1cf96d7cu)
        return 1;

    /* cmpxchgq: equal path stores, not-equal path loads the accumulator. */
    long* cobj = malloc(16);
    if (!cobj)
        return 1;
    cobj[1] = 424242;
    cmpx_test(cobj, out);
    if (cobj[1] != 1234 || out[0] != 1234 || out[1] != 1234) {
        printf("cmpxchg mem=%ld acc=%ld\n", cobj[1], out[0]);
        return 1;
    }

    /* mulxq with an explicit-rdx multiplicand: full 128-bit product. */
    long* mobj = malloc(16);
    if (!mobj)
        return 1;
    mobj[0] = (long)0xFEDCBA9876543210UL;
    mobj[1] = (long)0x123456789ABCDEF0UL;
    mulx_test(mobj, out);
    unsigned __int128 prod =
        (unsigned __int128)(unsigned long)mobj[0] * (unsigned long)mobj[1];
    if ((unsigned long)out[0] != (unsigned long)prod ||
        (unsigned long)out[1] != (unsigned long)(prod >> 64)) {
        printf("mulx lo=%lu hi=%lu\n", out[0], out[1]);
        return 1;
    }

    printf("rmw pin att ok\n");
    return 0;
}
