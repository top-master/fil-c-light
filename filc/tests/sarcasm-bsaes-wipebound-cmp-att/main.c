#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void bsaes_wipe_r11(void *base, long rounds);
void bsaes_wipe_rbp(void *base, void *end);

static int failures = 0;

// The r11 (`ja`) spelling must wipe exactly [base, base+rounds*128-96).
static void run_r11(long rounds, int tag) {
    size_t total = (size_t)rounds * 128 + 64;
    size_t wiped = (size_t)rounds * 128 - 96;
    unsigned char *buf = malloc(total);
    memset(buf, 0xAB, total);
    bsaes_wipe_r11(buf, rounds);
    for (size_t i = 0; i < wiped; i++) {
        if (buf[i] != 0) {
            printf("BAD tag%d r11 round%ld byte%zu not wiped\n",
                tag, rounds, i);
            failures++;
            break;
        }
    }
    for (size_t i = wiped; i < total; i++) {
        if (buf[i] != 0xAB) {
            printf("BAD tag%d r11 round%ld byte%zu over-wiped\n",
                tag, rounds, i, buf[i]);
            failures++;
            break;
        }
    }
    free(buf);
}

// The rbp (`jb`) spelling wipes exactly the first 32-byte chunk (its
// exit condition trips once rax passes base+32), whatever end says,
// except when the whole range is one chunk, where both agree.
static void run_rbp(long rounds, int tag) {
    size_t total = (size_t)rounds * 128 + 64;
    size_t size = (size_t)rounds * 128 - 96;
    size_t expect = size < 32 ? size : 32;
    unsigned char *buf = malloc(total);
    memset(buf, 0xCD, total);
    bsaes_wipe_rbp(buf, buf + size);
    for (size_t i = 0; i < expect; i++) {
        if (buf[i] != 0) {
            printf("BAD tag%d rbp round%ld byte%zu not wiped\n",
                tag, rounds, i);
            failures++;
            break;
        }
    }
    for (size_t i = expect; i < total; i++) {
        if (buf[i] != 0xCD) {
            printf("BAD tag%d rbp round%ld byte%zu over-wiped\n",
                tag, rounds, i, buf[i]);
            failures++;
            break;
        }
    }
    free(buf);
}

int main(void) {
    run_r11(1, 1);
    run_r11(7, 2);
    run_r11(14, 3);
    run_rbp(1, 4);   // size 32: both spellings wipe the one chunk
    run_rbp(2, 5);   // size 224: rbp spelling stops after 32
    run_rbp(14, 6);
    if (failures == 0)
        printf("bsaes wipebound cmp ok\n");
    else
        printf("bsaes wipebound cmp BAD (%d)\n", failures);
    return failures != 0;
}
