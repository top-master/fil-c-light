#include <stdio.h>
#include <string.h>
#include <stdint.h>

/* cvt_s64(a) = trunc(a + a) * 2 + a = 5a: 85.
   cvt_u64(-1): ucvtf(x)=2^64 (rounded), fcvtzu saturates to 2^64-1 = -1;
     ucvtf(w)=4294967295, fcvtzu=4294967295; sum = 4294967294.
   cvt_u64(42) = 42 + 42 = 84.
   cvt_ds(bits): double->single->double roundtrip, truncated twice. The
     w-form fcvtzs zero-extends into x, so negatives come out huge:
     3.99 -> 3 + 3 = 6; -17.75 -> -17 + 0xFFFFFFEF = 4294967262.
   cvt_hf(a): int->single->half->{double,single}, truncated twice (same
     zero-extension for the negative): 100 -> 200; -37 -> 4294967222.
   cvt_sat(dbits, fbits): fcvtzs of DBL_MAX saturates to INT64_MAX, fcvtzs of
     FLT_MAX saturates to INT32_MAX; sum wraps to -9223372034707292162. */
long cvt_s64(long a);
long cvt_u64(long a);
long cvt_ds(long bits);
long cvt_hf(long a);
long cvt_sat(long dbits, long fbits);

static long dbits(double d)
{
    uint64_t u;
    memcpy(&u, &d, 8);
    return (long)u;
}

int main()
{
    printf("cvt %ld %ld %ld %ld %ld %ld %ld\n",
           cvt_s64(17), cvt_u64(-1L), cvt_u64(42), cvt_ds(dbits(3.99)),
           cvt_ds(dbits(-17.75)), cvt_hf(100), cvt_hf(-37));
    printf("sat %ld\n", cvt_sat(dbits(1.7976931348623157e308), 0x7F7FFFFFL));
    return 0;
}
