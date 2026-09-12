#include <time.h>
#include <stdfil.h>
#include <stdint.h>

int main()
{
    uintptr_t addr = 0x12345678;
    clock_gettime(CLOCK_REALTIME, (struct timespec*)addr);
    return 0;
}