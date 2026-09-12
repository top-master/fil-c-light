#include <time.h>
#include <stdfil.h>
#include <stdlib.h>

int main()
{
    struct timespec *ts = malloc(sizeof(struct timespec));
    ZASSERT(ts);
    free(ts);
    clock_gettime(CLOCK_REALTIME, ts);
    return 0;
}