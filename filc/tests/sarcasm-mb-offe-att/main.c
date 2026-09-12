#include <stdio.h>
#include <string.h>

void mboffe_run(void *src, void *dst);

static int failures = 0;

static void run_case(int tag) {
    unsigned char src[64], dst[64];
    for (int i = 0; i < 64; i++)
        src[i] = (unsigned char)(tag * 23 + i * 5 + 3);
    memset(dst, 0xEE, sizeof dst);
    mboffe_run(src, dst);
    if (memcmp(dst, src, sizeof dst) != 0) {
        printf("BAD tag%d offe round-trip\n", tag);
        failures++;
    }
}

int main(void) {
    run_case(1);
    run_case(2);
    if (failures == 0)
        printf("mb offe ok\n");
    else
        printf("mb offe BAD (%d)\n", failures);
    return failures != 0;
}
