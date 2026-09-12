#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

/* Success-by-masking: the masked slow paths must let accesses through when
   every ENABLED lane is inside [lower, upper), even though the full-width
   footprint is out of bounds — and must let a zero mask through at any
   in-object-OOB address. */

long below_load(void* p, long k);
long above_load(void* p, long k);
long below_store(void* p, long k);
long above_store(void* p, long k);
long zero_below(void* p, long k);
long zero_above(void* p, long k);

static uint64_t buf[8] __attribute__((aligned(64)));

int main()
{
    int i;
    for (i = 0; i < 8; i++)
        buf[i] = 100 + i;

    /* (a) BELOW: base = buf-16 (OOB): vmovdqu64 {z}-load with mask 0b1100 —
       only lanes 2,3 are enabled; they read buf[0], buf[1]. The helper sums
       the extracted lanes 2,3. */
    long r = below_load((char*)buf - 16, 0xC);
    if (r != 100 + 101) {
        printf("below_load: got %ld want %d\n", r, 201);
        return 1;
    }

    /* (b) ABOVE: base = buf+56: only lane 0 is in bounds (reads buf[7]). */
    r = above_load((char*)buf + 56, 0x1);
    if (r != 107) {
        printf("above_load: got %ld want %d\n", r, 107);
        return 1;
    }

    /* below STORE: base = buf-16, mask 0b1100 — writes lanes 2,3 (= buf[0],
       buf[1]) with the store value 55; the out-of-object lanes are masked off. */
    buf[0] = 1; buf[1] = 2;
    r = below_store((char*)buf - 16, 0xC);
    if (r != 3 || buf[0] != 55 || buf[1] != 55) {
        printf("below_store: r=%ld buf=[%llu,%llu]\n", r,
               (unsigned long long)buf[0], (unsigned long long)buf[1]);
        return 1;
    }

    /* above STORE: base = buf+56, mask 0b1 — writes lane 0 (= buf[7]) with 77. */
    buf[7] = 9;
    r = above_store((char*)buf + 56, 0x1);
    if (r != 4 || buf[7] != 77) {
        printf("above_store: r=%ld buf[7]=%llu\n", r, (unsigned long long)buf[7]);
        return 1;
    }

    /* (c) mask == 0 at an in-object-OOB address (below AND above): survives
       (the masked-off access touches no memory). Load and store forms. */
    if (zero_below((char*)buf - 64, 0) != 6) {
        printf("zero_below load failed\n");
        return 1;
    }
    if (zero_above((char*)buf + 64, 0) != 8) {
        printf("zero_above store failed\n");
        return 1;
    }

    printf("masked slowpath ok\n");
    return 0;
}
