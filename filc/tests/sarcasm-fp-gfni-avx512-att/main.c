#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

void gf_mul_zmm(void* p);
void gf_aff_zmm(void* p);

/* GF(2^8) multiply reference model, reduction polynomial x^8+x^4+x^3+x+1 (0x11B). */
static uint8_t gmul(uint8_t a, uint8_t b)
{
    uint8_t p = 0;
    int i;
    for (i = 0; i < 8; i++) {
        if (b & 1)
            p ^= a;
        uint8_t hi = a & 0x80;
        a <<= 1;
        if (hi)
            a ^= 0x1B;
        b >>= 1;
    }
    return p;
}

static uint32_t rng_state = 67890;
static uint8_t next_byte(void)
{
    rng_state = rng_state * 1103515245 + 12345;
    return (uint8_t)(rng_state >> 16);
}

int main()
{
    int i;

    /* EVEX zmm vgf2p8mulb: 64-byte memory operand. */
    uint8_t* blk = malloc(192);  /* a[64] b[64] out[64] */
    if (!blk)
        return 1;
    for (i = 0; i < 64; i++) {
        blk[i] = next_byte();
        blk[64 + i] = next_byte();
        blk[128 + i] = 0xAA;
    }
    gf_mul_zmm(blk);
    for (i = 0; i < 64; i++) {
        uint8_t want = gmul(blk[i], blk[64 + i]);
        if (blk[128 + i] != want) {
            printf("gf_mul_zmm byte %d: got %02x want %02x\n", i, blk[128 + i], want);
            return 1;
        }
    }

    /* EVEX zmm vgf2p8affineqb with the identity matrix: byte-exact. */
    uint64_t* aff = malloc(192); /* in[64] mat[8] out[64] */
    if (!aff)
        return 1;
    for (i = 0; i < 64; i++)
        ((uint8_t*)aff)[i] = next_byte();
    for (i = 0; i < 8; i++)
        aff[8 + i] = 0x0102040810204080ULL;
    memset((uint8_t*)aff + 128, 0xAA, 64);
    gf_aff_zmm(aff);
    for (i = 0; i < 64; i++) {
        if (((uint8_t*)aff)[128 + i] != ((uint8_t*)aff)[i]) {
            printf("gf_aff_zmm byte %d: got %02x want %02x\n",
                   i, ((uint8_t*)aff)[128 + i], ((uint8_t*)aff)[i]);
            return 1;
        }
    }

    printf("gfni512 ok\n");
    return 0;
}
