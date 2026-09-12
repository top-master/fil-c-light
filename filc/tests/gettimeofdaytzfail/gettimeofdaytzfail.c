#include <sys/time.h>
#include <stdfil.h>
#include <stddef.h>
#include <pizlonated_syscalls.h>

int main()
{
    // Test: out-of-bounds high for timezone*
    struct timezone tz[10];
    zsys_gettimeofday(NULL, tz + 1000);
    return 0;
}