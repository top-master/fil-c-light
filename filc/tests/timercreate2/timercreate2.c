
#include <signal.h>
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <pthread.h>

#define ASSERT(exp) do { \
        if ((exp)) \
            break; \
        fprintf(stderr, "%s:%d: %s: assertion %s failed.\n", __FILE__, __LINE__, __PRETTY_FUNCTION__, #exp); \
        abort(); \
    } while (false)

static bool functioned = false;

static void function(union sigval sigval)
{
    functioned = true;
}

int main()
{
    unsigned n;
    for (n = 100; n--;) {
        struct sigevent sev;
        timer_t timer;
        struct itimerspec it;
        
        ASSERT(!functioned);
        memset(&sev, 0, sizeof(sev));
        sev.sigev_notify = SIGEV_THREAD;
        sev.sigev_notify_function = function;
        ASSERT(!timer_create(CLOCK_REALTIME, &sev, &timer));
        it.it_interval.tv_sec = 0;
        it.it_interval.tv_nsec = 0;
        it.it_value.tv_sec = 0;
        it.it_value.tv_nsec = 1000000;
        ASSERT(!timer_settime(timer, 0, &it, NULL));
        while (!functioned) asm volatile("" : : : "memory");
        timer_getoverrun(timer);
        ASSERT(!timer_delete(timer));
        functioned = false;
    }
    
    return 0;
}

