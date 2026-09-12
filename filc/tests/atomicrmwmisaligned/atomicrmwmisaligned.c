#include <pthread.h>
#include <stdio.h>

/* A 16-byte integer with only 8-byte alignment (deliberately NOT _Atomic, since _Atomic
   would promote the alignment to 16). Atomic RMW operations on this cannot use cmpxchg16b,
   which requires 16-byte alignment, so a pre-pass in the pizlonator
   (convertMisalignedAtomicsToLibcalls in FilPizlonator.cpp) converts them into a load + CAS
   loop: the current value is read with the lock-based __atomic_load libcall, the new value
   is recomputed from the loaded value (buildAtomicRMWValue in FilPizlonator.cpp), and the
   loop retries with the lock-based __atomic_compare_exchange libcall until it succeeds. The
   libcalls are implemented in libpizlo (see filc/src/runtime.c).

   This test exercises the value recomputation for fetch_add, fetch_sub, fetch_and,
   fetch_or, fetch_xor, and fetch_nand, checking both the returned old value and the stored
   new value of every op, using operands with bits set above 2^64 so that truncation bugs
   would be caught. */
typedef __int128 misaligned_i128 __attribute__((aligned(8)));

static misaligned_i128 g;

static void print_i128(misaligned_i128 v)
{
    unsigned long long hi = (unsigned long long)((unsigned __int128)v >> 64);
    unsigned long long lo = (unsigned long long)v;
    printf("0x%llx%016llx", hi, lo);
}

static int ok = 1;

static void check_value(const char* what, misaligned_i128 actual, misaligned_i128 expected)
{
    if (actual != expected) {
        printf("FAIL: %s: got ", what);
        print_i128(actual);
        printf(", expected ");
        print_i128(expected);
        printf("\n");
        ok = 0;
    }
}

/* The expected values are computed with plain unsigned arithmetic (which cannot overflow
   into undefined behavior) so they can be checked against the atomic ops. */
static misaligned_i128 add128(misaligned_i128 a, misaligned_i128 b)
{
    return (misaligned_i128)((unsigned __int128)a + (unsigned __int128)b);
}

static misaligned_i128 sub128(misaligned_i128 a, misaligned_i128 b)
{
    return (misaligned_i128)((unsigned __int128)a - (unsigned __int128)b);
}

static misaligned_i128 make128(unsigned long long hi, unsigned long long lo)
{
    return (misaligned_i128)(((unsigned __int128)hi << 64) | (unsigned __int128)lo);
}

#define NTHREADS 4
#define COUNT 250000

static void* adder_main(void* arg)
{
    unsigned long long* my_sum = (unsigned long long*)arg;
    unsigned long long sum = 0;
    unsigned n;
    for (n = 0; n < COUNT; n++)
        sum += (unsigned long long)__atomic_fetch_add(&g, 1, __ATOMIC_SEQ_CST);
    *my_sum = sum;
    return NULL;
}

int main(void)
{
    _Static_assert(sizeof(misaligned_i128) == 16, "misaligned_i128 is 16 bytes");
    _Static_assert(_Alignof(misaligned_i128) == 8, "misaligned_i128 has 8-byte alignment");

    misaligned_i128 current = make128(0x123456789abcdef0ULL, 0x0fedcba987654321ULL);
    misaligned_i128 operand, old, now;

    __atomic_store(&g, &current, __ATOMIC_SEQ_CST);
    printf("start = ");
    print_i128(current);
    printf("\n");

    operand = make128(0x00fedcba98765432ULL, 0x1111111111111111ULL);
    old = __atomic_fetch_add(&g, operand, __ATOMIC_SEQ_CST);
    __atomic_load(&g, &now, __ATOMIC_SEQ_CST);
    check_value("fetch_add old", old, current);
    check_value("fetch_add stored", now, add128(current, operand));
    printf("fetch_add old = ");
    print_i128(old);
    printf(" new = ");
    print_i128(now);
    printf("\n");
    current = now;

    operand = make128(0x0000000000000001ULL, 0xffffffffffffffffULL);
    old = __atomic_fetch_sub(&g, operand, __ATOMIC_SEQ_CST);
    __atomic_load(&g, &now, __ATOMIC_SEQ_CST);
    check_value("fetch_sub old", old, current);
    check_value("fetch_sub stored", now, sub128(current, operand));
    printf("fetch_sub old = ");
    print_i128(old);
    printf(" new = ");
    print_i128(now);
    printf("\n");
    current = now;

    operand = make128(0x0f0f0f0f0f0f0f0fULL, 0xffffffff00000000ULL);
    old = __atomic_fetch_and(&g, operand, __ATOMIC_SEQ_CST);
    __atomic_load(&g, &now, __ATOMIC_SEQ_CST);
    check_value("fetch_and old", old, current);
    check_value("fetch_and stored", now, current & operand);
    printf("fetch_and old = ");
    print_i128(old);
    printf(" new = ");
    print_i128(now);
    printf("\n");
    current = now;

    operand = make128(0x00ff00ff00ff00ffULL, 0x00000000ffffffffULL);
    old = __atomic_fetch_or(&g, operand, __ATOMIC_SEQ_CST);
    __atomic_load(&g, &now, __ATOMIC_SEQ_CST);
    check_value("fetch_or old", old, current);
    check_value("fetch_or stored", now, current | operand);
    printf("fetch_or old = ");
    print_i128(old);
    printf(" new = ");
    print_i128(now);
    printf("\n");
    current = now;

    operand = make128(0x0aaa0aaa0aaa0aaaULL, 0x5555555555555555ULL);
    old = __atomic_fetch_xor(&g, operand, __ATOMIC_SEQ_CST);
    __atomic_load(&g, &now, __ATOMIC_SEQ_CST);
    check_value("fetch_xor old", old, current);
    check_value("fetch_xor stored", now, current ^ operand);
    printf("fetch_xor old = ");
    print_i128(old);
    printf(" new = ");
    print_i128(now);
    printf("\n");
    current = now;

    operand = make128(0x0fffffffffffffffULL, 0xff00ff00ff00ff00ULL);
    old = __atomic_fetch_nand(&g, operand, __ATOMIC_SEQ_CST);
    __atomic_load(&g, &now, __ATOMIC_SEQ_CST);
    check_value("fetch_nand old", old, current);
    check_value("fetch_nand stored", now, ~(current & operand));
    printf("fetch_nand old = ");
    print_i128(old);
    printf(" new = ");
    print_i128(now);
    printf("\n");
    current = now;

    printf("final = ");
    print_i128(current);
    printf("\n");

    /* Multithreaded check: 4 threads each do COUNT fetch_adds of 1, so the final value is
       exactly NTHREADS * COUNT. Also, the old values returned by the fetch_adds are
       exactly the integers 0 .. NTHREADS*COUNT-1 in some order, so their sum is
       deterministic too. */
    {
        misaligned_i128 zero = make128(0, 0);
        __atomic_store(&g, &zero, __ATOMIC_SEQ_CST);

        pthread_t threads[NTHREADS];
        unsigned long long sums[NTHREADS];
        unsigned n;
        for (n = 0; n < NTHREADS; n++) {
            sums[n] = 0;
            pthread_create(threads + n, NULL, adder_main, sums + n);
        }
        for (n = 0; n < NTHREADS; n++)
            pthread_join(threads[n], NULL);

        __atomic_load(&g, &now, __ATOMIC_SEQ_CST);
        check_value("threaded fetch_add total", now, make128(0, NTHREADS * COUNT));
        printf("threaded sum = %lld\n", (long long)now);

        unsigned long long total_old = 0;
        for (n = 0; n < NTHREADS; n++)
            total_old += sums[n];
        if (total_old != (unsigned long long)(NTHREADS * COUNT) * (NTHREADS * COUNT - 1) / 2) {
            printf("FAIL: threaded old-value sum: got %llu, expected %llu\n", total_old,
                   (unsigned long long)(NTHREADS * COUNT) * (NTHREADS * COUNT - 1) / 2);
            ok = 0;
        }
        printf("threaded old-value sum = %llu\n", total_old);
    }

    if (!ok)
        return 1;
    printf("success\n");
    return 0;
}
