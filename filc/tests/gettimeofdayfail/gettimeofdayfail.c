#include <sys/time.h>
#include <stdfil.h>
#include <stddef.h>
#include <pizlonated_syscalls.h>

int main()
{
    // Test: out-of-bounds high for timeval*
    struct timeval tv[10];
    zsys_gettimeofday(tv + 1000, NULL);
    return 0;
}