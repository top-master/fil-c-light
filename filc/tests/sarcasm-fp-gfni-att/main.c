#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

void gf_mul(void* p);
void gf_aff(void* p);
void gf_mul_ymm(void* p);

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

static uint32_t rng_state = 12345;
static uint8_t next_byte(void)
{
    rng_state = rng_state * 1103515245 + 12345;
    return (uint8_t)(rng_state >> 16);
}

int main()
{
    int i, round;

    /* xmm gf2p8mulb: deterministic + pseudo-random inputs, cross-checked
       against the reference model. */
    uint8_t* blk = malloc(48);   /* a[16] b[16] out[16] */
    if (!blk)
        return 1;
    for (round = 0; round < 4; round++) {
        for (i = 0; i < 16; i++) {
            blk[i] = round ? next_byte() : (uint8_t)(i * 17 + 1);
            blk[16 + i] = round ? next_byte() : (uint8_t)(i * 29 + 7);
            blk[32 + i] = 0xAA;
        }
        gf_mul(blk);
        for (i = 0; i < 16; i++) {
            uint8_t want = gmul(blk[i], blk[16 + i]);
            if (blk[32 + i] != want) {
                printf("gf_mul round %d byte %d: got %02x want %02x\n",
                       round, i, blk[32 + i], want);
                return 1;
            }
        }
    }

    /* gf2p8affineqb with the identity matrix returns the input byte-exact. */
    uint64_t* aff = malloc(48);  /* in[16] mat[2] out[16] */
    if (!aff)
        return 1;
    for (i = 0; i < 16; i++)
        ((uint8_t*)aff)[i] = next_byte();
    aff[2] = 0x0102040810204080ULL;   /* identity bit matrix */
    aff[3] = 0x0102040810204080ULL;
    memset((uint8_t*)aff + 32, 0xAA, 16);
    gf_aff(aff);
    for (i = 0; i < 16; i++) {
        if (((uint8_t*)aff)[32 + i] != ((uint8_t*)aff)[i]) {
            printf("gf_aff byte %d: got %02x want %02x\n",
                   i, ((uint8_t*)aff)[32 + i], ((uint8_t*)aff)[i]);
            return 1;
        }
    }

    /* VEX ymm vgf2p8mulb: 32-byte memory operand. */
    uint8_t* yblk = malloc(96);  /* a[32] b[32] out[32] */
    if (!yblk)
        return 1;
    for (i = 0; i < 32; i++) {
        yblk[i] = next_byte();
        yblk[32 + i] = next_byte();
        yblk[64 + i] = 0xAA;
    }
    gf_mul_ymm(yblk);
    for (i = 0; i < 32; i++) {
        uint8_t want = gmul(yblk[i], yblk[32 + i]);
        if (yblk[64 + i] != want) {
            printf("gf_mul_ymm byte %d: got %02x want %02x\n", i, yblk[64 + i], want);
            return 1;
        }
    }

    printf("gfni ok\n");
    return 0;
}
