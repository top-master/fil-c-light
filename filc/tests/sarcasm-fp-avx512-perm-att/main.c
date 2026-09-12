#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

long perm_t2d(void* p);
long compress_expand(void* in, void* out);

int main()
{
    int i;
    /* vpermt2d with a 64-byte memory source operand: result lane i takes
       idx[i] < 16 ? a[idx[i]] : b[idx[i] - 16]. The struct is exactly
       192 bytes and the b[] load spans its last 64 bytes. */
    uint32_t* blk = malloc(192);   /* idx[16] a[16] b[16] */
    if (!blk)
        return 1;
    uint32_t* idx = blk;
    uint32_t* a = blk + 16;
    uint32_t* b = blk + 32;
    for (i = 0; i < 16; i++) {
        idx[i] = (i * 7 + 3) % 32;
        a[i] = 1000 + i;
        b[i] = 2000 + i;
    }
    perm_t2d(blk);
    for (i = 0; i < 16; i++) {
        uint32_t j = (i * 7 + 3) % 32;
        uint32_t want = j < 16 ? 1000 + j : 2000 + (j - 16);
        if (a[i] != want) {
            printf("perm lane %d: got %u want %u\n", i, a[i], want);
            return 1;
        }
    }

    /* Unmasked compress/expand round-trip: all 16 dwords stored contiguously
       and loaded back byte-exact. */
    uint32_t* in = malloc(64);
    uint32_t* out = malloc(64);
    if (!in || !out)
        return 1;
    for (i = 0; i < 16; i++) {
        in[i] = i * 2654435761u + 12345u;
        out[i] = 0xAAAAAAAA;
    }
    compress_expand(in, out);
    for (i = 0; i < 16; i++) {
        if (out[i] != in[i]) {
            printf("roundtrip lane %d: got %08x want %08x\n", i, out[i], in[i]);
            return 1;
        }
    }

    printf("perm ok\n");
    return 0;
}
