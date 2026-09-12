#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

void bmi_q(void* in, void* out);

static unsigned long pdep_ref(unsigned long src, unsigned long mask)
{
    unsigned long r = 0;
    int bit = 0;
    int i;
    for (i = 0; i < 64; i++) {
        if (mask & (1UL << i)) {
            if (src & (1UL << bit))
                r |= 1UL << i;
            bit++;
        }
    }
    return r;
}

static unsigned long pext_ref(unsigned long src, unsigned long mask)
{
    unsigned long r = 0;
    int bit = 0;
    int i;
    for (i = 0; i < 64; i++) {
        if (mask & (1UL << i)) {
            if (src & (1UL << i))
                r |= 1UL << bit;
            bit++;
        }
    }
    return r;
}

int main()
{
    /* 16-byte object; the q-form test value occupies its LAST 8 bytes, so
       every memory read in bmi_q is at the object end. */
    unsigned long* obj = malloc(16);
    unsigned long* out = malloc(15 * sizeof(long));
    if (!obj || !out)
        return 1;
    unsigned long V = 0xA5C396B4D2E1F087UL;
    obj[1] = V;
    memset(out, 0, 15 * sizeof(long));

    bmi_q(obj, out);

    unsigned long S = 0x1111111111111111UL;
    unsigned long expect[13];
    expect[0] = V << 7;                        /* shlxq */
    expect[1] = V >> 7;                        /* shrxq */
    expect[2] = (unsigned long)((long)V >> 7); /* sarxq */
    expect[3] = (V >> 13) | (V << (64 - 13));  /* rorxq $13 */
    expect[4] = V & (0UL - V);                 /* blsiq */
    expect[5] = V & (V - 1);                   /* blsrq */
    expect[6] = V ^ (V - 1);                   /* blsmskq */
    expect[7] = (V >> 4) & ((1UL << 20) - 1);  /* bextrq start=4 len=20 */
    expect[8] = V & ((1UL << 23) - 1);         /* bzhiq index=23 */
    expect[9] = pdep_ref(S, V);                /* pdepq */
    expect[10] = pext_ref(S, V);               /* pextq */
    int i;
    for (i = 0; i < 64; i++) {                 /* bsfq */
        if (V & (1UL << i)) {
            expect[11] = i;
            break;
        }
    }
    for (i = 63; i >= 0; i--) {                /* bsrq */
        if (V & (1UL << i)) {
            expect[12] = i;
            break;
        }
    }
    for (i = 0; i < 13; i++) {
        if (out[i] != expect[i]) {
            printf("bmi_q out[%d]=%lu want %lu\n", i, out[i], expect[i]);
            return 1;
        }
    }

    /* andnl: 4-byte read of the LAST 4 bytes of the object (high half of V). */
    uint32_t andn;
    memcpy(&andn, (char*)out + 104, 4);
    uint32_t expect_andn = ~0x0F0F0F0Fu & (uint32_t)(V >> 32);
    if (andn != expect_andn) {
        printf("andnl=%u want %u\n", andn, expect_andn);
        return 1;
    }

    printf("bmi att ok\n");
    return 0;
}
