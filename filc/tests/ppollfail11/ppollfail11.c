#define _GNU_SOURCE
#include <poll.h>
#include <stdlib.h>
#include <stddef.h>
#include <time.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    struct timespec* ts = (struct timespec*)malloc(sizeof(struct timespec));
    ts = (struct timespec*)opaque(ts);
    ppoll(NULL, 0, ts - 1000, NULL);
    return 0;
}