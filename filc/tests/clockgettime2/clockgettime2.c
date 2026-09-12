#include <time.h>
#include <stdfil.h>
#include <stdlib.h>
#include "utils.h"

int main()
{
    struct timespec *ts = malloc(sizeof(struct timespec));
    ZASSERT(ts);
    clock_gettime(CLOCK_REALTIME, (struct timespec*)opaque(ts + 1000));
    return 0;
}