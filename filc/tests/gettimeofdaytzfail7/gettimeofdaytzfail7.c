#include <sys/time.h>
#include <stdfil.h>
#include <inttypes.h>
#include <stddef.h>
#include <pizlonated_syscalls.h>

int main()
{
    // Test: out-of-bounds pointer that would overflow when struct size is added
    struct timezone tz;
    struct timezone* ptr = (struct timezone*)((uintptr_t)&tz + UINTPTR_MAX - 4);
    zsys_gettimeofday(NULL, ptr);
    return 0;
}