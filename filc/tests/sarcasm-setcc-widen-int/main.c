/* Register-destination setcc widening: a setcc is modeled as a full-width def
   of its destination web, so sarcasm must make the hardware match by emitting
   the zero-extension after it. Every function here poisons all allocatable
   GPRs with 0x7777777777777777 and reads the setcc destination WIDER than 8
   bits — the exact pattern that silently exposed stale garbage in the web's
   upper 56 bits before the widening existed. The widened reads must be
   exactly 0 or 1. */
#include <stdio.h>

extern long sc_eq_one(void);
extern long sc_eq_zero(void);
extern long sc_ne_one(void);
extern long sc_lt_zero(void);
extern long sc_gt_one(void);
extern long sc_byte_one(void);
extern long sc_arg(long x);

static int fails = 0;
#define CHECK(call, want) do { \
    long got = (call); \
    if (got != (want)) { \
        printf("%s -> 0x%lx (want %ld)\n", #call, got, (long)(want)); \
        fails++; \
    } \
} while (0)

int main()
{
    CHECK(sc_eq_one(), 1);      /* ZF set: 0x7777... == itself */
    CHECK(sc_eq_zero(), 0);     /* ZF clear: 0x7777... != 5 */
    CHECK(sc_ne_one(), 1);      /* ZF clear: setne */
    CHECK(sc_lt_zero(), 0);     /* 0x7777... is not signed-less than 5 */
    CHECK(sc_gt_one(), 1);      /* 0x7777... is signed-greater than 5 */
    CHECK(sc_byte_one(), 1);    /* 8-bit read-back (manual movzbl idiom) */
    CHECK(sc_arg(42), 1);
    CHECK(sc_arg(41), 0);
    if (fails) {
        printf("setcc widen int FAILED (%d)\n", fails);
        return 1;
    }
    printf("setcc widen int ok\n");
    return 0;
}
