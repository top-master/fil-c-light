#include <sys/time.h>
#include <stdfil.h>
#include <stddef.h>
#include <pizlonated_syscalls.h>

int main()
{
    // Test: read-only memory write for timeval* (using string literal area)
    const char* str = "hello world";
    zsys_gettimeofday((struct timeval*)str, NULL);
    return 0;
}