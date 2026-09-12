#include <time.h>
#include <stdfil.h>

int main()
{
    const char *str = "hello world";
    clock_gettime(CLOCK_REALTIME, (struct timespec*)str);
    return 0;
}