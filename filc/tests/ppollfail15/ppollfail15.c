#define _GNU_SOURCE
#include <poll.h>
#include <stdint.h>
#include <stddef.h>
#include <time.h>
#include <stdfil.h>

int main()
{
    struct timespec* ts = (struct timespec*)(uintptr_t)12345678;
    ppoll(NULL, 0, ts, NULL);
    return 0;
}