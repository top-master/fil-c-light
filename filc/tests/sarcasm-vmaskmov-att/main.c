#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

/* AVX2 vector-masked loads/stores (vmaskmovps/pd, vpmaskmovd/q): the mask is
   the per-lane SIGN BITS of the explicit mask vector operand. They get the
   same mask-aware bounds check as the AVX512 {k} forms. */

long maskload_ps(void* p, long k);
long maskstore_q(void* p, long k);
long maskload_zero(void* p, long k);

static float fbuf[8] __attribute__((aligned(32)));
static uint64_t qbuf[4] __attribute__((aligned(32)));

int main()
{
    int i;
    for (i = 0; i < 8; i++)
        fbuf[i] = 1.0f + i;

    /* ymm vmaskmovps load with the mask vector's sign bits set on lanes
       0,2,5,7 (the helper builds the mask vector from k's bits): sum the
       loaded lanes. */
    long r = maskload_ps(fbuf, 0xA5);
    long want = 0;
    for (i = 0; i < 8; i++)
        if (0xA5 & (1 << i))
            want += (long)(1.0f + i);
    if (r != want) {
        printf("maskload_ps: got %ld want %ld\n", r, want);
        return 1;
    }

    /* ymm vpmaskmovq store at qbuf with sign bits on lanes 1,3: stores 88 to
       those qwords only. */
    for (i = 0; i < 4; i++)
        qbuf[i] = 50 + i;
    r = maskstore_q(qbuf, 0xA);
    for (i = 0; i < 4; i++) {
        uint64_t w = (0xA & (1 << i)) ? 88 : 50 + i;
        if (qbuf[i] != w) {
            printf("maskstore_q lane %d: got %llu want %llu\n", i,
                   (unsigned long long)qbuf[i], (unsigned long long)w);
            return 1;
        }
    }
    if (r != 12)
        return 1;

    /* zero mask at an in-object-OOB address (below): survives — the masked
       access touches nothing. */
    if (maskload_zero((char*)fbuf - 16, 0) != 14) {
        printf("maskload_zero failed\n");
        return 1;
    }

    printf("vmaskmov ok\n");
    return 0;
}
