#include <time.h>
#include <stdfil.h>
#include <stdlib.h>
#include <stdint.h>
#include "utils.h"

int main()
{
    struct timespec *ts = malloc(sizeof(struct timespec));
    ZASSERT(ts);
    // Create a pointer that will overflow when checked
    uintptr_t addr = (uintptr_t)ts;
    addr = UINTPTR_MAX - 8;  // Will overflow when size is added
    clock_gettime(CLOCK_REALTIME, (struct timespec*)opaque((void*)addr));
    return 0;
}