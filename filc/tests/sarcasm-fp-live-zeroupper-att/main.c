/* The zeroed-upper case: a movss load zeroes xmm3[4:16); a 128-bit movdqu
   store after the pollcheck-heavy loop reads the whole register, so the
   width-aware save/restore must keep 16 bytes live across the pollchecks
   (preserving the architecturally-zeroed upper bytes), not just the low 4.
   Verified via -S (movdqu at slot 3 — see zeroupper.s); asserted here under
   GC churn so the pollcheck slow path really runs. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <stdfil.h>
#include <filc_test_support.h>

long zero_upper(float* buf, long n);

#define ITERS 200000000L

static void* hammer(void* arg)
{
    int i;
    for (i = 0; i < 30; i++)
        zgc_request_and_wait();
    return NULL;
}

int main()
{
    float* buf = malloc(32);
    if (!buf)
        return 1;
    /* poison the bytes the movaps store will overwrite, incl. the upper 12 */
    memset(buf, 0x5a, 32);
    buf[0] = 1.5f;
    long iters = ITERS;
    if (zgc_is_stw())
        iters = ITERS / 100;
    pthread_t t;
    if (pthread_create(&t, NULL, hammer, NULL))
        return 1;
    long r = zero_upper(buf, iters);
    if (pthread_join(t, NULL))
        return 1;
    if (r != 0)
        return 1;
    if (buf[4] != 1.5f) {
        printf("zero upper BAD lane0 %f != 1.5\n", (double)buf[4]);
        return 1;
    }
    int i;
    for (i = 5; i < 8; i++) {
        if (buf[i] != 0.0f) {
            printf("zero upper BAD lane%d %f != 0.0 (zeroed upper bytes not preserved)\n",
                   i - 4, (double)buf[i]);
            return 1;
        }
    }
    printf("zero upper ok\n");
    return 0;
}
