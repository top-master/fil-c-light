#include <stdio.h>
#include <stdint.h>

void amm52x2(void* res, const void* a, const void* b, const void* m, const void* k0);

/* Dual-channel 8-limb AMM52 vectors: res = a*b*R^-1 mod m per channel with
   R = 2^(52*8). Reference values computed with python bignums (moduli are
   384-bit, inside the design domain 52*8 >= 384 + 2 of Gueron's Lemma 1).
   The kernel mirrors ossl_rsaz_amm52x30_x2_ifma256's dual-channel shape
   (vpmadd52luq/huq memops, valignq rotates, vpcmpuq/kmovb nibble dance,
   masked vpsubq), so an exact-match failure here means sarcasm misassembled
   one of those forms. */
static const uint64_t AV[16] = {
    0x000f36938e075878ULL, 0x00011e885987b6ceULL, 0x00058854d6967322ULL, 0x000bae4e5ff5adceULL, 0x0003bf46cf44542cULL, 0x000ed8eb555b6c5cULL, 0x0006f501bd4eff26ULL, 0x0000000000014abeULL, 0x000f3641cd961c89ULL, 0x000c653f931afae8ULL, 0x000ea5cb5c59c6e3ULL, 0x000460cf84bc1f80ULL, 0x000eba7316addce3ULL, 0x000ecf09e6deec04ULL, 0x000c00ccd481d42fULL, 0x000000000007038fULL
};
static const uint64_t BV[16] = {
    0x00088b6f989c3b87ULL, 0x000235304c07c0ebULL, 0x000e64ce63626ab9ULL, 0x0001e4f97bea471aULL, 0x000dcf801dd6c9a7ULL, 0x000caf977dce3685ULL, 0x0001ce25cd4963f9ULL, 0x0000000000025b9aULL, 0x000d31352eda3141ULL, 0x0002f9263645e372ULL, 0x0009ee0a80142e40ULL, 0x00054f6a60417b2bULL, 0x000cc35e76d95111ULL, 0x0008203fc6bf65e7ULL, 0x00053c8533b37febULL, 0x000000000004d3c0ULL
};
static const uint64_t MV[16] = {
    0x000d028dae1305cfULL, 0x000822bb572fb811ULL, 0x0002fa2aee4d447cULL, 0x0004a9f9837dd4dfULL, 0x00063407d20e0e63ULL, 0x00004f279d3a9407ULL, 0x0002b1508ce82c2eULL, 0x000000000009b5ccULL, 0x0004b12f2da2d70bULL, 0x0009c285d5b487dcULL, 0x0009de43f0516ef9ULL, 0x000db6fdc7d1b355ULL, 0x0000548da61f3068ULL, 0x0009221d9f8c4f8bULL, 0x00076a265a3ce88eULL, 0x00000000000a9736ULL
};
static const uint64_t EXPV[16] = {
    0x0002a24baca01299ULL, 0x0002a1fa5359d48fULL, 0x0006d840b14332c3ULL, 0x0002a32850956c90ULL, 0x0003506069759a09ULL, 0x0004b10b4e9b4bc7ULL, 0x0002699b0cbeaf08ULL, 0x000000000007dc76ULL, 0x00092baf6ff781b6ULL, 0x0001b9c486658c42ULL, 0x00001e77b309bbf9ULL, 0x000956602d9af06eULL, 0x000a5ee2bd9d5765ULL, 0x000a86717f0a9e64ULL, 0x000a5ad2b3389332ULL, 0x00000000000a0333ULL
};
static const uint64_t K0V[2] = { 0x334eeb2358161ed1ULL, 0x60f19be6a2b0435dULL };

#define M52 0xFFFFFFFFFFFFFULL

int main()
{
    uint64_t res[16] = { 0 };
    amm52x2(res, AV, BV, MV, K0V);
    for (int ch = 0; ch < 2; ch++) {
        for (int i = 0; i < 8; i++) {
            uint64_t got = res[8 * ch + i] & M52;
            uint64_t want = EXPV[8 * ch + i] & M52;
            if (got != want) {
                printf("ch%d limb %d: got %012llx want %012llx\n", ch, i,
                       (unsigned long long)got, (unsigned long long)want);
                return 1;
            }
        }
    }
    printf("amm52x2 att ok\n");
    return 0;
}
