#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

long bcast_b(void* in, void* out);
long bcast_w(void* in, void* out);
long bcast_d(void* in, void* out);
long bcast_q(void* in, void* out);
long bcast_d_reg(void* in, void* out);

int main()
{
    int i;
    /* Each input is a heap object of EXACTLY the element size: the broadcast
       load must be checked at element width (1/2/4/8 bytes). A full 32-byte
       vector-width check would trap on these small objects. */
    uint8_t* inb = malloc(1);
    uint8_t* inw = malloc(2);
    uint8_t* ind = malloc(4);
    uint8_t* inq = malloc(8);
    uint8_t* out = malloc(32);
    if (!inb || !inw || !ind || !inq || !out)
        return 1;

    /* vpbroadcastb: all 32 byte lanes must equal the loaded byte. */
    *inb = 0xAB;
    memset(out, 0, 32);
    bcast_b(inb, out);
    for (i = 0; i < 32; i++) {
        if (out[i] != 0xAB) {
            printf("b lane %d: got %02x want ab\n", i, out[i]);
            return 1;
        }
    }

    /* vpbroadcastw: all 16 word lanes must equal the loaded word. */
    *(uint16_t*)inw = 0xCD42;
    memset(out, 0, 32);
    bcast_w(inw, out);
    for (i = 0; i < 16; i++) {
        if (((uint16_t*)out)[i] != 0xCD42) {
            printf("w lane %d: got %04x want cd42\n", i, ((uint16_t*)out)[i]);
            return 1;
        }
    }

    /* vpbroadcastd: all 8 dword lanes must equal the loaded dword. */
    *(uint32_t*)ind = 0x12345678;
    memset(out, 0, 32);
    bcast_d(ind, out);
    for (i = 0; i < 8; i++) {
        if (((uint32_t*)out)[i] != 0x12345678) {
            printf("d lane %d: got %08x want 12345678\n", i, ((uint32_t*)out)[i]);
            return 1;
        }
    }

    /* vpbroadcastq: all 4 qword lanes must equal the loaded qword. */
    *(uint64_t*)inq = 0x1122334455667788ULL;
    memset(out, 0, 32);
    bcast_q(inq, out);
    for (i = 0; i < 4; i++) {
        if (((uint64_t*)out)[i] != 0x1122334455667788ULL) {
            printf("q lane %d: got %016lx want 1122334455667788\n",
                   i, ((uint64_t*)out)[i]);
            return 1;
        }
    }

    /* xmm-source vpbroadcastd: all 8 dword lanes must equal the xmm1 element. */
    *(uint32_t*)ind = 0xCAFEBABE;
    memset(out, 0, 32);
    bcast_d_reg(ind, out);
    for (i = 0; i < 8; i++) {
        if (((uint32_t*)out)[i] != 0xCAFEBABE) {
            printf("d-reg lane %d: got %08x want cafebabe\n", i, ((uint32_t*)out)[i]);
            return 1;
        }
    }

    printf("broadcast ok\n");
    return 0;
}
