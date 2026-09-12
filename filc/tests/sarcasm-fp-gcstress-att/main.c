/* Canary for sarcasm's vector-register save/restore around injected runtime calls:
   fpsum_gc keeps two FP accumulators live in xmm0/xmm7 across ~2e9 loop back-edges
   (pollchecks fire). A helper thread hammers zgc_request_and_wait() so the pollcheck
   slow path (filc_pollcheck_slow) runs repeatedly. If the slow path clobbers the
   live xmm registers, the sums come back garbage. */
#include <stdio.h>
#include <pthread.h>
#include <stdfil.h>
#include <filc_test_support.h>

long fpsum_gc(long n);

#define ITERS 2000000000L

static void* hammer(void* arg)
{
    int i;
    for (i = 0; i < 30; i++)
        zgc_request_and_wait();
    return NULL;
}

int main()
{
    long iters = ITERS;
    if (zgc_is_stw())
        iters = ITERS / 100;
    pthread_t t;
    if (pthread_create(&t, NULL, hammer, NULL))
        return 1;
    long r = fpsum_gc(iters);
    if (pthread_join(t, NULL))
        return 1;
    if (r != 3 * iters) {
        printf("gcstress BAD %ld != %ld\n", r, 3 * iters);
        return 1;
    }
    printf("gcstress ok\n");
    return 0;
}
