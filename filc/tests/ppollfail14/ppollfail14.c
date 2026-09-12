#define _GNU_SOURCE
#include <poll.h>
#include <stddef.h>
#include <time.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    struct timespec* ts = (struct timespec*)opaque(zweak_map_new());
    ppoll(NULL, 0, ts, NULL);
    return 0;
}