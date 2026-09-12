/* LSE compare-exchange through sarcasm: cas/casb/cash and the 16-byte casp
   (x-pairs and w-pairs), checked exactly against a C model — the old value
   lands in the compare register, memory updates only on a match, and NZCV
   after the instruction reflects the compare (cset/b.eq consumers). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdfil.h>
#include <filc_test_support.h>

#define ASSERT(exp) do { \
    if ((exp)) \
        break; \
    fprintf(stderr, "%s:%d: %s: assertion %s failed.\n", \
            __FILE__, __LINE__, __PRETTY_FUNCTION__, #exp); \
    abort(); \
} while (0)

long cas64(long* cell, long expected, long desired);
long cas64a(long* cell, long expected, long desired);
long cas64l(long* cell, long expected, long desired);
long cas64al(long* cell, long expected, long desired);
long cas64_zf(long* cell, long expected, long desired);
long cas64_beq(long* cell, long expected, long desired);
int cas32(int* cell, int expected, int desired);
int casb(unsigned char* cell, int expected, int desired);
int cash(unsigned short* cell, int expected, int desired);
long casp_test(long* expected_pair, long* desired_pair, long* cell);
long caspal_test(long* expected_pair, long* desired_pair, long* cell);
long caspw_test(int* expected_pair, int* desired_pair, int* cell);

typedef long (*cas_fn)(long*, long, long);

struct cas_case { const char* name; cas_fn fn; };

static const struct cas_case cas_cases[] = {
    { "cas",   cas64 },
    { "casa",  cas64a },
    { "casl",  cas64l },
    { "casal", cas64al },
};

static const long seeds[] = { 0, 1, 100, -50, 0x1234, -1, 0x7fffffffffffffffL };
static const long exps[] = { 0, 1, -50, 2, -1, 0x7fffffffffffffffL };
static const long dess[] = { 7, -25, 0x100, 0, -1 };

int main()
{
    long* cell = malloc(sizeof(long));
    int* icell = malloc(sizeof(int));
    unsigned char* bcell = malloc(16);
    unsigned short* hcell = malloc(16);
    ASSERT(cell && icell && bcell && hcell);
    size_t i, j, k, l;

    /* match AND mismatch paths, old-value return + final memory */
    for (i = 0; i < sizeof(cas_cases) / sizeof(cas_cases[0]); i++) {
        for (j = 0; j < sizeof(seeds) / sizeof(seeds[0]); j++) {
            for (k = 0; k < sizeof(exps) / sizeof(exps[0]); k++) {
                for (l = 0; l < sizeof(dess) / sizeof(dess[0]); l++) {
                    long mc = seeds[j];
                    long want_old = mc;
                    int matched = (mc == exps[k]);
                    if (matched)
                        mc = dess[l];
                    *cell = seeds[j];
                    long got_old = cas_cases[i].fn(cell, exps[k], dess[l]);
                    if (*cell != mc || got_old != want_old) {
                        printf("%s: seed=%ld exp=%ld des=%ld: cell=%ld want %ld,"
                               " old=%ld want %ld\n",
                               cas_cases[i].name, seeds[j], exps[k], dess[l],
                               *cell, mc, got_old, want_old);
                        return 1;
                    }
                }
            }
        }
    }

    /* flag consumers: cset and b.eq immediately after the cas */
    for (j = 0; j < sizeof(seeds) / sizeof(seeds[0]); j++) {
        for (k = 0; k < sizeof(exps) / sizeof(exps[0]); k++) {
            int matched = (seeds[j] == exps[k]);
            *cell = seeds[j];
            ASSERT(cas64_zf(cell, exps[k], 42) == matched);
            ASSERT(*cell == (matched ? 42 : seeds[j]));
            *cell = seeds[j];
            ASSERT(cas64_beq(cell, exps[k], 43) == matched);
            ASSERT(*cell == (matched ? 43 : seeds[j]));
        }
    }

    /* the retry idiom: walk the cell upward with compare-exchange */
    *cell = 0;
    for (i = 0; i < 100; i++) {
        long cur;
        for (;;) {
            cur = *cell;
            if (cas64_zf(cell, cur, cur + 3))
                break;
        }
        ASSERT(*cell == (long)(i * 3 + 3));
    }

    /* 32-bit cas on an int cell */
    *icell = 1234;
    ASSERT(cas32(icell, 1234, 5678) == 1234);
    ASSERT(*icell == 5678);
    ASSERT(cas32(icell, 1234, 9999) == 5678);
    ASSERT(*icell == 5678);

    /* byte and halfword forms */
    *bcell = 0x5a;
    ASSERT(casb(bcell, 0x5a, 0xa5) == 0x5a);
    ASSERT(*bcell == 0xa5);
    ASSERT(casb(bcell, 0x5a, 0x11) == 0xa5);
    ASSERT(*bcell == 0xa5);
    *hcell = 0x5a5a;
    ASSERT(cash(hcell, 0x5a5a, 0xa5a5) == 0x5a5a);
    ASSERT(*hcell == 0xa5a5);
    ASSERT(cash(hcell, 0x5a5a, 0x1111) == 0xa5a5);
    ASSERT(*hcell == 0xa5a5);

    /* casp: 16-byte compare-exchange, x-register pairs */
    long* pcell = malloc(2 * sizeof(long));
    long exp_pair[2], des_pair[2];
    ASSERT(pcell);
    pcell[0] = 100;
    pcell[1] = 200;
    /* match: exchanged, old pair returned, flag 1 */
    exp_pair[0] = 100; exp_pair[1] = 200;
    des_pair[0] = 300; des_pair[1] = 400;
    ASSERT(casp_test(exp_pair, des_pair, pcell) == 1);
    ASSERT(exp_pair[0] == 100 && exp_pair[1] == 200);
    ASSERT(pcell[0] == 300 && pcell[1] == 400);
    /* mismatch on the first half: not exchanged, old pair returned, flag 0 */
    exp_pair[0] = 100; exp_pair[1] = 200;
    des_pair[0] = 500; des_pair[1] = 600;
    ASSERT(casp_test(exp_pair, des_pair, pcell) == 0);
    ASSERT(exp_pair[0] == 300 && exp_pair[1] == 400);
    ASSERT(pcell[0] == 300 && pcell[1] == 400);
    /* mismatch on the second half only */
    exp_pair[0] = 300; exp_pair[1] = 999;
    ASSERT(casp_test(exp_pair, des_pair, pcell) == 0);
    ASSERT(exp_pair[0] == 300 && exp_pair[1] == 400);
    ASSERT(pcell[0] == 300 && pcell[1] == 400);
    /* the caspal ordering variant, match + mismatch */
    exp_pair[0] = 300; exp_pair[1] = 400;
    des_pair[0] = -1; des_pair[1] = -2;
    ASSERT(caspal_test(exp_pair, des_pair, pcell) == 1);
    ASSERT(exp_pair[0] == 300 && exp_pair[1] == 400);
    ASSERT(pcell[0] == -1 && pcell[1] == -2);
    exp_pair[0] = 300; exp_pair[1] = 400;
    ASSERT(caspal_test(exp_pair, des_pair, pcell) == 0);
    ASSERT(exp_pair[0] == -1 && exp_pair[1] == -2);
    ASSERT(pcell[0] == -1 && pcell[1] == -2);

    /* casp w-pairs: an 8-byte compare-exchange as two 32-bit halves, at an
       8-aligned-but-not-16 address (its natural alignment) */
    int* wcell = (int*)((char*)malloc(32) + 8);
    int wexp[2], wdes[2];
    ASSERT(wcell);
    wcell[0] = 111;
    wcell[1] = 222;
    wexp[0] = 111; wexp[1] = 222;
    wdes[0] = 333; wdes[1] = 444;
    ASSERT(caspw_test(wexp, wdes, wcell) == 1);
    ASSERT(wexp[0] == 111 && wexp[1] == 222);
    ASSERT(wcell[0] == 333 && wcell[1] == 444);
    wexp[0] = 111; wexp[1] = 222;
    wdes[0] = 555; wdes[1] = 666;
    ASSERT(caspw_test(wexp, wdes, wcell) == 0);
    ASSERT(wexp[0] == 333 && wexp[1] == 444);
    ASSERT(wcell[0] == 333 && wcell[1] == 444);

    /* under allocation churn (GC marking) the checked-CAS sequences and the
       casp pair pinning keep working */
    size_t repeat = 20000;
    if (zgc_is_stw())
        repeat = 1000;
    *cell = 0;
    for (i = 0; i < repeat; i++) {
        void* junk = malloc(64);
        memset(junk, 1, 64);
        free(junk);
        ASSERT(cas64_zf(cell, (long)i, (long)(i + 1)) == 1);
    }
    ASSERT(*cell == (long)repeat);
    printf("cas arm ok\n");
    return 0;
}
