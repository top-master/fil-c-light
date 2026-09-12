#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

/* {k}-masked truncating stores (vpmovqb & family): E = the memory element
   size, N = the memory lane count, V = N*E (not the source vector width). */

long trunc_qb(void* p, long k);
long trunc_dw(void* p, long k);
long trunc_qb_below(void* p, long k);

static char buf[16] __attribute__((aligned(16)));

int main()
{
    int i;
    memset(buf, 0, sizeof(buf));

    /* vpmovqb zmm -> 8 bytes with mask 0x0F: stores the low bytes of qwords
       0..3 (values 0x11..0x44) to buf[0..3]. */
    long r = trunc_qb(buf, 0x0F);
    for (i = 0; i < 4; i++) {
        if (buf[i] != (char)(0x11 * (i + 1))) {
            printf("trunc_qb lane %d: got %d\n", i, buf[i]);
            return 1;
        }
    }
    for (i = 4; i < 8; i++) {
        if (buf[i] != 0) {
            printf("trunc_qb masked-off lane %d wrote\n", i);
            return 1;
        }
    }
    if (r != 5)
        return 1;

    /* vpmovdw zmm -> 32 bytes... at buf (16 bytes!): full footprint OOB, but
       with mask 0x00FF (lanes 0..7) the... no: the fixed-position check
       requires the whole footprint for a NONZERO... lane 7 of 16 words at
       buf+14 is in bounds; mask 0x00FF enables lanes 0..7 = words 0..7 at
       [0,16): all in bounds. Stores 0x77 to words 0..7. */
    memset(buf, 0, sizeof(buf));
    r = trunc_dw(buf, 0x00FF);
    for (i = 0; i < 8; i++) {
        if (buf[2 * i] != 0x77 || buf[2 * i + 1] != 0) {
            printf("trunc_dw word %d: got %02x%02x\n", i,
                   buf[2 * i + 1] & 0xFF, buf[2 * i] & 0xFF);
            return 1;
        }
    }
    if (r != 6)
        return 1;

    /* success-by-masking below: vpmovqb at buf-4 with mask 0xF0 (lanes 4..7
       -> bytes at buf[0..3]); the out-of-object lanes 0..3 are masked off. */
    memset(buf, 0, sizeof(buf));
    r = trunc_qb_below(buf - 4, 0xF0);
    for (i = 0; i < 4; i++) {
        if (buf[i] != (char)0x42) {
            printf("trunc_qb_below lane %d: got %d\n", i, buf[i]);
            return 1;
        }
    }
    if (r != 7)
        return 1;

    printf("masked trunc ok\n");
    return 0;
}
