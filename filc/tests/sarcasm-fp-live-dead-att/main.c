/* xmm2/xmm4 are written before the loop but overwritten (pxor) inside it
   and never read afterwards: they are DEAD across the loop pollchecks, so
   the width-aware fp save/restore expansion emits no save/restore movs at
   those sites at all (-S verified, see dead.s). Behaviorally this runs the
   loop under GC stress (the result does not depend on the xmm state); the
   point is the emitted shape, and the run double-checks the empty expansion
   is not confused into corrupting control flow. */
#include <stdio.h>
#include <pthread.h>
#include <stdfil.h>
#include <filc_test_support.h>

long dead_regs(long n);

#define ITERS 200000000L

static void* hammer(void* arg)
{
    int i;
    for (i = 0; i < 20; i++)
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
    long r = dead_regs(iters);
    if (pthread_join(t, NULL))
        return 1;
    if (r != 0) {
        printf("dead regs BAD %ld != 0\n", r);
        return 1;
    }
    printf("dead regs ok\n");
    return 0;
}
