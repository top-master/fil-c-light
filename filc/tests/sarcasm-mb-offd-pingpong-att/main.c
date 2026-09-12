#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void mboffd_run(void *src, void *dst, void *key);

static int failures = 0;

static void run_case(int tag) {
    unsigned char src[256], dst[256], key[16], want[256];
    for (int i = 0; i < 256; i++)
        src[i] = (unsigned char)(tag * 29 + i * 3 + 7);
    for (int i = 0; i < 16; i++)
        key[i] = (unsigned char)(tag * 17 + i * 11 + 5);
    memset(dst, 0xEE, sizeof dst);
    mboffd_run(src, dst, key);
    // The IV half (src[128..256)) drains to dst[0..128) xored with the
    // key (the vpxor tail shape); the ciphertext half (src[0..128))
    // drains to dst[128..256) verbatim (the offload shape).
    for (int i = 0; i < 128; i++)
        want[i] = (unsigned char)(src[128 + i] ^ key[i % 16]);
    memcpy(want + 128, src, 128);
    if (memcmp(dst, want, sizeof dst) != 0) {
        printf("BAD tag%d pingpong round-trip\n", tag);
        failures++;
    }
}

int main(void) {
    // Two different blocks back to back: the second must not see any
    // stale bytes from the first (both ping-pong areas fully rewritten).
    run_case(1);
    run_case(2);
    run_case(3);
    if (failures == 0)
        printf("mb offd pingpong ok\n");
    else
        printf("mb offd pingpong BAD (%d)\n", failures);
    return failures != 0;
}
