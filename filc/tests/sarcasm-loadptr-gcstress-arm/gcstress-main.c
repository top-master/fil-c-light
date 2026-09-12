/* GC stress for a sarcasm-assembled loop that does two invisicap pointer loads per
   iteration (two lazily-rooted lower slots) plus pointer arithmetic on both arguments,
   with a pollcheck on every iteration. If sarcasm leaves root slots uninitialized, the
   GC may observe stack garbage as a capability at a pollcheck. Run many threads with
   allocation churn so the GC constantly scans frames. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <stdfil.h>
#include <filc_test_support.h>

#define ASSERT(exp) do { \
    if ((exp)) \
        break; \
    fprintf(stderr, "%s:%d: %s: assertion %s failed.\n", \
            __FILE__, __LINE__, __PRETTY_FUNCTION__, #exp); \
    abort(); \
} while (0)

unsigned long sum2(unsigned char** a, unsigned char** b);

#define N 8
/* 'a'..'h' = 97..104, sum = 804 per array, 1608 total. */
#define EXPECT 1608

static size_t num_threads = 10;
static size_t repeat = 2000000;

static void* worker(void* arg)
{
    unsigned char** a = malloc((N + 1) * sizeof(unsigned char*));
    unsigned char** b = malloc((N + 1) * sizeof(unsigned char*));
    ASSERT(a);
    ASSERT(b);
    size_t i, j;
    for (j = 0; j < N; j++) {
        char* sa = malloc(2);
        char* sb = malloc(2);
        ASSERT(sa);
        ASSERT(sb);
        sa[0] = (char)('a' + j);
        sa[1] = 0;
        sb[0] = (char)('a' + j);
        sb[1] = 0;
        a[j] = (unsigned char*)sa;
        b[j] = (unsigned char*)sb;
    }
    a[N] = NULL;
    b[N] = NULL;
    for (i = 0; i < repeat; i++) {
        ASSERT(sum2(a, b) == EXPECT);
        /* churn so the GC keeps marking/scanning */
        void* p = malloc(64);
        memset(p, 1, 64);
        free(p);
    }
    for (j = 0; j < N; j++) {
        free(a[j]);
        free(b[j]);
    }
    free(a);
    free(b);
    return NULL;
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
