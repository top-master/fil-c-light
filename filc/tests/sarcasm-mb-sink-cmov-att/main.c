#include <stdio.h>

long mb_cmov_in_sunk(long counter);
long mb_cmov_out_sunk(long counter);
long mb_cmov_prologue_sunk(long count);

int main(void) {
    int ok = 1;
    // Loop input cancel: sunk iff counter <= 1.
    long in_counters[] = {0, 1, 2, 3, 4, 5, 100, 1000000};
    int in_want[] = {1, 1, 0, 0, 0, 0, 0, 0};
    for (int i = 0; i < 8; i++) {
        long got = mb_cmov_in_sunk(in_counters[i]);
        if (got != in_want[i]) {
            printf("BAD in counter=%ld got=%ld want=%d\n",
                in_counters[i], got, in_want[i]);
            ok = 0;
        }
    }
    // Loop output cancel: sunk iff counter == 0.
    long out_counters[] = {0, 1, 2, 3, 4, 5, 100, 1000000};
    int out_want[] = {1, 0, 0, 0, 0, 0, 0, 0};
    for (int i = 0; i < 8; i++) {
        long got = mb_cmov_out_sunk(out_counters[i]);
        if (got != out_want[i]) {
            printf("BAD out counter=%ld got=%ld want=%d\n",
                out_counters[i], got, out_want[i]);
            ok = 0;
        }
    }
    // Prologue cancel: sunk iff count == 0.
    long pro_counters[] = {0, 1, 2, 3, 100};
    int pro_want[] = {1, 0, 0, 0, 0};
    for (int i = 0; i < 5; i++) {
        long got = mb_cmov_prologue_sunk(pro_counters[i]);
        if (got != pro_want[i]) {
            printf("BAD prologue count=%ld got=%ld want=%d\n",
                pro_counters[i], got, pro_want[i]);
            ok = 0;
        }
    }
    // The asymmetry itself: at counter==1 the input is already sunk while
    // the output is still live (last live block stores live, next-block
    // load is dummy); at counter==0 both are sunk.
    if (!(mb_cmov_in_sunk(1) == 1 && mb_cmov_out_sunk(1) == 0)) {
        printf("BAD asymmetry at counter==1\n");
        ok = 0;
    }
    if (!(mb_cmov_in_sunk(0) == 1 && mb_cmov_out_sunk(0) == 1)) {
        printf("BAD both-sunk at counter==0\n");
        ok = 0;
    }
    if (ok)
        printf("mb cmov asymmetry ok\n");
    else
        printf("mb cmov asymmetry BAD\n");
    return !ok;
}
