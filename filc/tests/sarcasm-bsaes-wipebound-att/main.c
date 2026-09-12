#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void bsaes_wipebound(void *base, long rounds);

static int failures = 0;

static void run_case(long rounds, int tag) {
    // Generous tail: the wipe must stop exactly at base+rounds*128-96.
    size_t total = (size_t)rounds * 128 + 64;
    unsigned char *buf = malloc(total);
    memset(buf, 0xAB, total);
    bsaes_wipebound(buf, rounds);
    size_t wiped = (size_t)rounds * 128 - 96;
    for (size_t i = 0; i < wiped; i++) {
        if (buf[i] != 0) {
            printf("BAD tag%d round%ld byte%zu not wiped: 0x%02x\n",
                tag, rounds, i, buf[i]);
            failures++;
            break;
        }
    }
    for (size_t i = wiped; i < total; i++) {
        if (buf[i] != 0xAB) {
            printf("BAD tag%d round%ld byte%zu over-wiped: 0x%02x\n",
                tag, rounds, i, buf[i]);
            failures++;
            break;
        }
    }
    free(buf);
}

int main(void) {
    run_case(1, 1);
    run_case(2, 2);
    run_case(7, 3);
    run_case(9, 4);
    run_case(10, 5);
    run_case(12, 6);
    run_case(14, 7);
    // Short-path analog: the smallest schedule still wipes exactly.
    run_case(1, 8);
    if (failures == 0)
        printf("bsaes wipebound ok\n");
    else
        printf("bsaes wipebound BAD (%d)\n", failures);
    return failures != 0;
}
