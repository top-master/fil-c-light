#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

long bcast_d_gpr(long a, long b, void* out);
long bcast_b_gpr(long a, long b, void* out);
long bcast_w_gpr(long a, long b, void* out);
long bcast_q_gpr(long a, long b, void* out);

int main()
{
    int i;
    uint8_t* out = malloc(16);
    if (!out)
        return 1;

    /* vpbroadcastd %eax: the source is a*b computed in the function. Every
       dword lane must be 42 (6*7) — a stale-register broadcast would give
       6 or 7. */
    memset(out, 0, 16);
    bcast_d_gpr(6, 7, out);
    for (i = 0; i < 4; i++) {
        if (((uint32_t*)out)[i] != 42) {
            printf("d-gpr lane %d: got %u want 42\n", i, ((uint32_t*)out)[i]);
            return 1;
        }
    }

    /* vpbroadcastb %eax: source a+b computed in the function. */
    memset(out, 0, 16);
    bcast_b_gpr(100, 111, out);   /* 211 = 0xD3 */
    for (i = 0; i < 16; i++) {
        if (out[i] != 0xD3) {
            printf("b-gpr lane %d: got %02x want d3\n", i, out[i]);
            return 1;
        }
    }

    /* vpbroadcastw %eax: source a-b computed in the function. */
    memset(out, 0, 16);
    bcast_w_gpr(5000, 1234, out);   /* 3766 = 0x0EB6 */
    for (i = 0; i < 8; i++) {
        if (((uint16_t*)out)[i] != 3766) {
            printf("w-gpr lane %d: got %u want 3766\n", i, ((uint16_t*)out)[i]);
            return 1;
        }
    }

    /* vpbroadcastq %rax: source a^b computed in the function. */
    memset(out, 0, 16);
    uint64_t qa = 0x1122334455667788ULL, qb = 0x0101010101010101ULL;
    bcast_q_gpr((long)qa, (long)qb, out);
    uint64_t qwant = qa ^ qb;
    for (i = 0; i < 2; i++) {
        if (((uint64_t*)out)[i] != qwant) {
            printf("q-gpr lane %d: got %016lx want %016lx\n",
                   i, ((uint64_t*)out)[i], qwant);
            return 1;
        }
    }

    printf("broadcast-gpr ok\n");
    return 0;
}
