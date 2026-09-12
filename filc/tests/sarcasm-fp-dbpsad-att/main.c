#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

void dbpsad(void* in, void* out);

/* vdbpsadbw reference model, derived from the SDM and cross-checked against
   hardware (Zen 5) over random inputs:
     word j (lane L = j/8, k = j%8, group g = k/4, position h = k%4):
       src1 window = src1 lane bytes [4*(k/2) .. 4*(k/2)+3]
       src2 span   = block(f0) concatenated with block(f1), where
                     f0 = imm8[4g+1:4g], f1 = imm8[4g+3:4g+2] and
                     block(x) = src2 lane bytes [4x .. 4x+3]
       src2 window = span bytes [h .. h+3]
       result      = sum of absolute byte differences                     */
static uint16_t sad_ref(const uint8_t* a, const uint8_t* b, int imm, int j)
{
    int L = j / 8, k = j % 8, g = k / 4, h = k % 4;
    const uint8_t* la = a + 16 * L;
    const uint8_t* lb = b + 16 * L;
    int f0 = (imm >> (4 * g)) & 3, f1 = (imm >> (4 * g + 2)) & 3;
    uint8_t span[8];
    int m;
    for (m = 0; m < 4; m++)
        span[m] = lb[4 * f0 + m];
    for (m = 0; m < 4; m++)
        span[4 + m] = lb[4 * f1 + m];
    uint16_t s = 0;
    for (m = 0; m < 4; m++) {
        int d = (int)la[4 * (k / 2) + m] - (int)span[h + m];
        s += d < 0 ? -d : d;
    }
    return s;
}

int main()
{
    uint8_t* in = malloc(128);
    uint16_t* out = malloc(128);
    if (!in || !out)
        return 1;
    int i;
    for (i = 0; i < 128; i++)
        in[i] = (uint8_t)(i * 37 + 11);
    dbpsad(in, out);
    int j;
    for (j = 0; j < 32; j++) {
        if (out[j] != sad_ref(in, in + 64, 0x1b, j)) {
            printf("imm=1b word %d: got %u want %u\n", j, out[j], sad_ref(in, in + 64, 0x1b, j));
            return 1;
        }
        if (out[32 + j] != sad_ref(in, in + 64, 0xe4, j)) {
            printf("imm=e4 word %d: got %u want %u\n", j, out[32 + j], sad_ref(in, in + 64, 0xe4, j));
            return 1;
        }
    }
    printf("dbpsad ok\n");
    return 0;
}
