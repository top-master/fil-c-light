#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

void ld_merge(void* p, long k);
void st_merge(void* p, long k);
long ld_dqu8(void* p, long k);
void st_ups(void* p, long k);
void ld_st_zero(void* p, long k);

/* In-bounds AVX512 {k}-masked loads/stores with various masks (all-ones,
   sparse, zero), merge and {z} forms, across element sizes and vector widths.
   The asm helpers take the writemask value in a GPR and kmov it themselves. */

static uint64_t buf[16] __attribute__((aligned(64)));
static float fbuf[16] __attribute__((aligned(64)));

int main()
{
    int i;
    for (i = 0; i < 16; i++)
        buf[i] = 1000 + i;

    /* zmm vmovdqu64 masked LOAD with merge mask 0xA5 into a pre-set dest:
       masked-off lanes keep the destination's previous value (7). The asm
       sets zmm0 = all-7, loads (%rdi) with {%k1} (no {z}), then sums all
       eight lanes and returns the sum. */
    extern long merge_load(const void* in, long k);
    long m = merge_load(buf, 0xA5);   /* lanes 0,2,5,7 from memory; others keep 7 */
    long wantSum = (1000 + 0) + (1000 + 2) + (1000 + 5) + (1000 + 7) + 4 * 7;
    if (m != wantSum) {
        printf("merge_load: got %ld want %ld\n", m, wantSum);
        return 1;
    }

    /* zmm masked STORE, sparse mask 0x3C (lanes 2..5): only those lanes land. */
    for (i = 0; i < 8; i++)
        buf[i] = 2000 + i;
    extern void sparse_store(void* p, long k);
    sparse_store(buf, 0x3C);      /* stores lane value 42 to lanes 2..5 */
    for (i = 0; i < 8; i++) {
        uint64_t want = (0x3C & (1 << i)) ? 42 : 2000 + i;
        if (buf[i] != want) {
            printf("sparse store lane %d: got %llu want %llu\n", i,
                   (unsigned long long)buf[i], (unsigned long long)want);
            return 1;
        }
    }

    /* ymm vmovdqu8 masked load with {z}, all-ones mask on the low 32 bytes:
       sum the 32 loaded bytes (each = its index). */
    char bytes[32] __attribute__((aligned(32)));
    for (i = 0; i < 32; i++)
        bytes[i] = (char)i;
    extern long byte_sum(void* p, long k);
    long s = byte_sum(bytes, 0xFFFFFFFF);
    if (s != (0 + 31) * 32 / 2) {
        printf("byte_sum: got %ld want %d\n", s, (0 + 31) * 32 / 2);
        return 1;
    }

    /* xmm vmovups masked store, mask 0x5 (lanes 0,2 of 4 floats). */
    for (i = 0; i < 4; i++)
        fbuf[i] = 1.5f + i;
    extern void ups_store(void* p, long k);
    ups_store(fbuf, 0x5);         /* stores 9.25f to lanes 0,2 */
    for (i = 0; i < 4; i++) {
        float want = (0x5 & (1 << i)) ? 9.25f : 1.5f + i;
        if (fbuf[i] != want) {
            printf("ups lane %d: got %f want %f\n", i, (double)fbuf[i], (double)want);
            return 1;
        }
    }

    /* zero-mask load and store at an in-bounds address: no memory touched,
       no state changed. */
    buf[0] = 777;
    extern long zero_mask(void* p, long k);
    if (zero_mask(buf, 0) != 5 || buf[0] != 777) {
        printf("zero_mask failed\n");
        return 1;
    }

    printf("masked move ok\n");
    return 0;
}
