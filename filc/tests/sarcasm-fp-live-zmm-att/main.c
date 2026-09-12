/* zmm1/zmm2 are live at the full 64 bytes across the loop pollchecks while
   a helper thread hammers the GC so the pollcheck slow path runs; zmm0/zmm3
   are written but dead there. The width-aware expansion must emit exactly
   two vmovdqu64 store/load pairs (slots 1 and 2, nothing for zmm0/zmm3) —
   verified via -S (see zmm.s). Behaviorally the sums must come back exact. */
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <stdfil.h>
#include <filc_test_support.h>

long zmm_live(float* buf, long n);

#define ITERS 50000000L

static void* hammer(void* arg)
{
    int i;
    for (i = 0; i < 30; i++)
        zgc_request_and_wait();
    return NULL;
}

int main()
{
    float* buf = malloc(128);
    if (!buf)
        return 1;
    int i;
    for (i = 0; i < 16; i++)
        buf[i] = 1.0f;
    for (i = 16; i < 32; i++)
        buf[i] = 2.0f;
    long iters = ITERS;
    if (zgc_is_stw())
        iters = ITERS / 100;
    pthread_t t;
    if (pthread_create(&t, NULL, hammer, NULL))
        return 1;
    long r = zmm_live(buf, iters);
    if (pthread_join(t, NULL))
        return 1;
    if (r != 0)
        return 1;
    /* zmm1 = 2*1.0 = 2.0, zmm2 = 2*2.0 = 4.0, result = zmm1 + zmm2 = 6.0
       in every one of the 16 lanes. */
    for (i = 0; i < 16; i++) {
        if (buf[i] != 6.0f) {
            printf("zmm live BAD buf[%d] = %f != 6.0\n", i, (double)buf[i]);
            return 1;
        }
    }
    printf("zmm live ok\n");
    return 0;
}
