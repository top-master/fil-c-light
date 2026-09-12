#include <stdio.h>
#include <pthread.h>
#include <stdfil.h>

void spin(void* p);

static void* thread_main(void* arg)
{
    spin(arg); /* infinite loop; sarcasm must have emitted a pollcheck in it */
    return NULL;
}

int main()
{
    pthread_t t;
    pthread_create(&t, NULL, thread_main, NULL);
    /* Completes only if the spinning thread reaches GC safepoints (i.e. sarcasm
       inserted a pollcheck in the loop); otherwise this deadlocks. */
    zgc_request_and_wait();
    printf("OK\n");
    return 0;
}
