#include <time.h>
#include <stdfil.h>
#include <stdlib.h>

int main()
{
    // malloc(0) gets rounded to 16 bytes, but struct timespec needs 16 bytes
    // so we have exactly 0 usable bytes for the struct
    void *buf = malloc(0);
    ZASSERT(buf);
    clock_gettime(CLOCK_REALTIME, (struct timespec*)buf);
    return 0;
}