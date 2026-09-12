#include <sys/time.h>
#include <stdfil.h>
#include <stddef.h>
#include <pizlonated_syscalls.h>

int main()
{
    // Test: special object pointer for timeval*
    zsys_gettimeofday(zweak_map_new(), NULL);
    return 0;
}