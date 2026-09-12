/* ARMv8.1 LSE atomics through sarcasm: swp/ldadd/ldclr/ldeor/ldset/ldsmax/
   ldsmin/ldumax/ldumin plus the st<op> no-return aliases, in the plain/a/l/al
   orderings and the b/h widths, checked exactly against a C model (both the
   old-value return and the final memory). */
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

long lse_swp(long* cell, long v);
long lse_swpa(long* cell, long v);
long lse_swpl(long* cell, long v);
long lse_swpal(long* cell, long v);
int lse_swpb(unsigned char* cell, int v);
int lse_swph(unsigned short* cell, int v);
long lse_ldadd(long* cell, long v);
long lse_ldadda(long* cell, long v);
long lse_ldaddl(long* cell, long v);
long lse_ldaddal(long* cell, long v);
int lse_ldaddb(unsigned char* cell, int v);
int lse_ldaddh(unsigned short* cell, int v);
long lse_ldclr(long* cell, long v);
long lse_ldeor(long* cell, long v);
long lse_ldset(long* cell, long v);
int lse_ldclrh(unsigned short* cell, int v);
long lse_ldsmax(long* cell, long v);
long lse_ldsmin(long* cell, long v);
long lse_ldumax(long* cell, long v);
long lse_ldumin(long* cell, long v);
void lse_stadd(long* cell, long v);
void lse_staddl(long* cell, long v);
void lse_stset(long* cell, long v);
void lse_stclr(long* cell, long v);
void lse_steor(long* cell, long v);

enum op { SWP, ADD, CLR, EOR, SET, SMAX, SMIN, UMAX, UMIN };

typedef long (*ld_fn)(long*, long);
typedef void (*st_fn)(long*, long);
typedef int (*ldb_fn)(unsigned char*, int);
typedef int (*ldh_fn)(unsigned short*, int);

static long model(enum op op, long* cell, long v)
{
    long old = *cell;
    switch (op) {
    case SWP:  *cell = v; break;
    case ADD:  *cell = old + v; break;
    case CLR:  *cell = old & ~v; break;
    case EOR:  *cell = old ^ v; break;
    case SET:  *cell = old | v; break;
    case SMAX: *cell = old > v ? old : v; break;
    case SMIN: *cell = old < v ? old : v; break;
    case UMAX: *cell = (unsigned long)old > (unsigned long)v ? old : v; break;
    case UMIN: *cell = (unsigned long)old < (unsigned long)v ? old : v; break;
    }
    return old;
}

static const long seeds[] = { 0, 1, 100, -50, 0x1234, -1, 0x7fffffffffffffffL,
                              -0x7fffffffffffffffL, 0xdeadbeef00L };
static const long vals[] = { 7, -25, 0x100, 1, -1, 0x5a5a5a5a5a5a5a5aL,
                             0x7fffffffffffffffL, -0x80000000L };

struct ld_case { const char* name; ld_fn fn; enum op op; };

static const struct ld_case ld_cases[] = {
    { "swp",     lse_swp,     SWP },
    { "swpa",    lse_swpa,    SWP },
    { "swpl",    lse_swpl,    SWP },
    { "swpal",   lse_swpal,   SWP },
    { "ldadd",   lse_ldadd,   ADD },
    { "ldadda",  lse_ldadda,  ADD },
    { "ldaddl",  lse_ldaddl,  ADD },
    { "ldaddal", lse_ldaddal, ADD },
    { "ldclr",   lse_ldclr,   CLR },
    { "ldeor",   lse_ldeor,   EOR },
    { "ldset",   lse_ldset,   SET },
    { "ldsmax",  lse_ldsmax,  SMAX },
    { "ldsmin",  lse_ldsmin,  SMIN },
    { "ldumax",  lse_ldumax,  UMAX },
    { "ldumin",  lse_ldumin,  UMIN },
};

struct st_case { const char* name; st_fn fn; enum op op; };

static const struct st_case st_cases[] = {
    { "stadd",  lse_stadd,  ADD },
    { "staddl", lse_staddl, ADD },
    { "stset",  lse_stset,  SET },
    { "stclr",  lse_stclr,  CLR },
    { "steor",  lse_steor,  EOR },
};

int main()
{
    long* cell = malloc(sizeof(long));
    unsigned char* bcell = malloc(16);
    unsigned short* hcell = malloc(16);
    ASSERT(cell && bcell && hcell);
    size_t nseeds = sizeof(seeds) / sizeof(seeds[0]);
    size_t nvals = sizeof(vals) / sizeof(vals[0]);
    size_t i, j, k;

    /* 64-bit ld<op>/swp: old-value return AND final memory, exactly */
    for (i = 0; i < sizeof(ld_cases) / sizeof(ld_cases[0]); i++) {
        for (j = 0; j < nseeds; j++) {
            for (k = 0; k < nvals; k++) {
                long mc = seeds[j];
                long want_old = model(ld_cases[i].op, &mc, vals[k]);
                *cell = seeds[j];
                long got_old = ld_cases[i].fn(cell, vals[k]);
                if (*cell != mc || got_old != want_old) {
                    printf("%s: seed=%ld v=%ld: cell=%ld want %ld, old=%ld want %ld\n",
                           ld_cases[i].name, seeds[j], vals[k], *cell, mc,
                           got_old, want_old);
                    return 1;
                }
            }
        }
    }

    /* st<op>: no return value, final memory only */
    for (i = 0; i < sizeof(st_cases) / sizeof(st_cases[0]); i++) {
        for (j = 0; j < nseeds; j++) {
            for (k = 0; k < nvals; k++) {
                long mc = seeds[j];
                model(st_cases[i].op, &mc, vals[k]);
                *cell = seeds[j];
                st_cases[i].fn(cell, vals[k]);
                if (*cell != mc) {
                    printf("%s: seed=%ld v=%ld: cell=%ld want %ld\n",
                           st_cases[i].name, seeds[j], vals[k], *cell, mc);
                    return 1;
                }
            }
        }
    }

    /* byte width: swpb, ldaddb */
    static const unsigned char bseeds[] = { 0, 1, 100, 255, 0x5a, 200 };
    static const unsigned char bvals[] = { 7, 25, 255, 1, 0xa5, 100 };
    for (j = 0; j < sizeof(bseeds) / sizeof(bseeds[0]); j++) {
        for (k = 0; k < sizeof(bvals) / sizeof(bvals[0]); k++) {
            unsigned char want, got;
            want = bseeds[j];
            *bcell = bseeds[j];
            got = (unsigned char)lse_swpb(bcell, bvals[k]);
            ASSERT(got == want);
            ASSERT(*bcell == bvals[k]);
            want = bseeds[j];
            *bcell = bseeds[j];
            got = (unsigned char)lse_ldaddb(bcell, bvals[k]);
            ASSERT(got == want);
            ASSERT(*bcell == (unsigned char)(want + bvals[k]));
        }
    }

    /* halfword width: swph, ldaddh, ldclrh */
    static const unsigned short hseeds[] = { 0, 1, 300, 65535, 0x5a5a, 40000 };
    static const unsigned short hvals[] = { 7, 1025, 65535, 1, 0xa5a5, 30000 };
    for (j = 0; j < sizeof(hseeds) / sizeof(hseeds[0]); j++) {
        for (k = 0; k < sizeof(hvals) / sizeof(hvals[0]); k++) {
            unsigned short want, got;
            want = hseeds[j];
            *hcell = hseeds[j];
            got = (unsigned short)lse_swph(hcell, hvals[k]);
            ASSERT(got == want);
            ASSERT(*hcell == hvals[k]);
            want = hseeds[j];
            *hcell = hseeds[j];
            got = (unsigned short)lse_ldaddh(hcell, hvals[k]);
            ASSERT(got == want);
            ASSERT(*hcell == (unsigned short)(want + hvals[k]));
            want = hseeds[j];
            *hcell = hseeds[j];
            got = (unsigned short)lse_ldclrh(hcell, hvals[k]);
            ASSERT(got == want);
            ASSERT(*hcell == (unsigned short)(want & ~hvals[k]));
        }
    }

    /* the same ops keep working under allocation churn (GC marking runs
       while the checked-access sequences execute) */
    size_t repeat = 30000;
    if (zgc_is_stw())
        repeat = 1000;
    *cell = 0;
    for (i = 0; i < repeat; i++) {
        void* junk = malloc(64);
        memset(junk, 1, 64);
        free(junk);
        long old = lse_ldadd(cell, 3);
        ASSERT(old == (long)(i * 3));
        ASSERT(*cell == (long)(i * 3 + 3));
    }
    printf("lse arm ok\n");
    return 0;
}
