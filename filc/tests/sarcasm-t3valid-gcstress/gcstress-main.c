/* GC stress for the sarcasm-assembled t3 hash: the generated hash frame declares two GC
   root slots (the `string` arg lower and the `string->bytes` invisicap load result), and
   its loop pollcheck runs before the bytes-lower root slot is written on each entry. If
   sarcasm leaves root slots uninitialized, the GC may observe stack garbage as a
   capability and die. Run many threads with allocation churn and stack-shape variety so
   the GC constantly scans frames in different states. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <stdfil.h>
#include <filc_test_support.h>
#include "utils.h"

#define ASSERT(exp) do { \
    if ((exp)) \
        break; \
    fprintf(stderr, "%s:%d: %s: assertion %s failed.\n", \
            __FILE__, __LINE__, __PRETTY_FUNCTION__, #exp); \
    abort(); \
} while (0)

struct String { unsigned char* bytes; size_t size; };
unsigned long hash(struct String* string);

static size_t num_threads = 10;
static size_t repeat = 5000000;

/* Leave wild-integer values over the native-stack region that the next call's frame (and
   hence its GC root slots) will overlap. The values come from volatile loads (so they
   can't be rematerialized) and are all live across a clobbering call (so they spill
   across this frame); the following hash call's frame then reuses that region. */
static volatile unsigned long junk_source = 0xdeadbeef12345678UL;

__attribute__((noinline)) static unsigned long dirty_stack(void)
{
    unsigned long a0 = junk_source, a1 = junk_source + 1, a2 = junk_source + 2;
    unsigned long a3 = junk_source + 3, a4 = junk_source + 4, a5 = junk_source + 5;
    unsigned long a6 = junk_source + 6, a7 = junk_source + 7, a8 = junk_source + 8;
    unsigned long a9 = junk_source + 9, a10 = junk_source + 10, a11 = junk_source + 11;
    unsigned long a12 = junk_source + 12, a13 = junk_source + 13, a14 = junk_source + 14;
    unsigned long a15 = junk_source + 15, a16 = junk_source + 16, a17 = junk_source + 17;
    unsigned long a18 = junk_source + 18, a19 = junk_source + 19, a20 = junk_source + 20;
    unsigned long a21 = junk_source + 21, a22 = junk_source + 22, a23 = junk_source + 23;
    unsigned long a24 = junk_source + 24, a25 = junk_source + 25, a26 = junk_source + 26;
    unsigned long a27 = junk_source + 27, a28 = junk_source + 28, a29 = junk_source + 29;
    unsigned long a30 = junk_source + 30, a31 = junk_source + 31;
    opaque(NULL);   /* clobbers caller-saved regs: the values must be in the frame */
    return a0 ^ a1 ^ a2 ^ a3 ^ a4 ^ a5 ^ a6 ^ a7 ^ a8 ^ a9 ^ a10 ^ a11
        ^ a12 ^ a13 ^ a14 ^ a15 ^ a16 ^ a17 ^ a18 ^ a19 ^ a20 ^ a21 ^ a22 ^ a23
        ^ a24 ^ a25 ^ a26 ^ a27 ^ a28 ^ a29 ^ a30 ^ a31;
}

static void* worker(void* arg)
{
    struct String s = { (unsigned char*)"hello", 5 };
    unsigned long sink = 0;
    size_t i;
    for (i = 0; i < repeat; i++) {
        sink ^= dirty_stack();
        ASSERT(hash(&s) == 210714636441UL);
        /* churn so the GC keeps marking/scanning */
        void* p = malloc(128);
        memset(p, 1, 128);
        free(p);
    }
    return (void*)sink;
}

int main()
{
    if (zgc_is_stw()) {
        num_threads = 2;
        repeat = 2000;
    }
    pthread_t th[num_threads];
    size_t i;
    for (i = 0; i < num_threads; i++)
        ASSERT(!pthread_create(&th[i], NULL, worker, NULL));
    for (i = 0; i < num_threads; i++)
        ASSERT(!pthread_join(th[i], NULL));
    printf("ok\n");
    return 0;
}
