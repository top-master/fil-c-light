#include <time.h>
#include <stdfil.h>

int main()
{
    clock_gettime(CLOCK_REALTIME, (struct timespec*)zweak_map_new());
    return 0;
}