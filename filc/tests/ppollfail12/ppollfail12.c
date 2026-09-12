#define _GNU_SOURCE
#include <poll.h>
#include <stdlib.h>
#include <stddef.h>
#include <time.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    // Allocate too little space for a timespec - use malloc(1) and point past the end
    char* small_buf = (char*)malloc(1);
    small_buf = (char*)opaque(small_buf);
    struct timespec* ts = (struct timespec*)(small_buf + 8);
    ppoll(NULL, 0, ts, NULL);
    return 0;
}