#include <sys/time.h>
#include <stdfil.h>
#include <inttypes.h>
#include <stddef.h>
#include <pizlonated_syscalls.h>

int main()
{
    // Test: integer cast to pointer for timeval*
    zsys_gettimeofday((struct timeval*)0x1010101010101010UL, NULL);
    return 0;
}