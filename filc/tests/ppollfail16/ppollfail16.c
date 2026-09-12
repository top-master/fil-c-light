#define _GNU_SOURCE
#include <poll.h>
#include <stdlib.h>
#include <stdint.h>
#include <stddef.h>
#include <time.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    struct timespec* ts = (struct timespec*)malloc(sizeof(struct timespec));
    ts = (struct timespec*)opaque(ts);
    // Create a pointer that will overflow
    ts = (struct timespec*)((uintptr_t)ts + SIZE_MAX - 1000);
    ppoll(NULL, 0, ts, NULL);
    return 0;
}