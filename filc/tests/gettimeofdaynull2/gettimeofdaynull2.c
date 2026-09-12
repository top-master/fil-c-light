#include <sys/time.h>
#include <stdfil.h>
#include <stddef.h>
#include <pizlonated_syscalls.h>

int main()
{
    // timeval* NULL, timezone* valid - should succeed
    struct timezone tz;
    int result = zsys_gettimeofday(NULL, &tz);
    ZASSERT(result == 0);
    return 0;
}