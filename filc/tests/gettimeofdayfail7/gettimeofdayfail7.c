#include <sys/time.h>
#include <stdfil.h>
#include <inttypes.h>
#include <stddef.h>
#include <pizlonated_syscalls.h>

int main()
{
    // Test: out-of-bounds pointer that would overflow when struct size is added
    struct timeval tv;
    struct timeval* ptr = (struct timeval*)((uintptr_t)&tv + UINTPTR_MAX - 4);
    zsys_gettimeofday(ptr, NULL);
    return 0;
}