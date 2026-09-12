#include <stdio.h>

/* Regression test for dense fast-CC packing when pointer args come AFTER scalars.
   For long(long, long, ptr), pizlonated clang packs the argument words densely:
   arg0 in rdx, arg1 in rcx, arg2's intval in r8 and its lower in r9. sarcasm's old
   fixed-pair packing read arg1 from r8 and only coincidentally agreed with dense
   packing when pointer args came first, so this shape (scalars first, pointer last)
   is the one that catches it: with the old packing arg1 reads as the pointer's
   intval and the result is garbage instead of 103. */
long llp(long a, long b, long* p);

int main()
{
    long x = 3;
    printf("%ld\n", llp(40, 60, &x));   /* 40 + 60 + *p = 103 */
    return 0;
}
