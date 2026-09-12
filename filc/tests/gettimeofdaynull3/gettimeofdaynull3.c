#include <sys/time.h>
#include <stdfil.h>
#include <stddef.h>
#include <pizlonated_syscalls.h>

int main()
{
    // timeval* valid, timezone* NULL - should succeed
    struct timeval tv;
    int result = zsys_gettimeofday(&tv, NULL);
    ZASSERT(result == 0);
    return 0;
}