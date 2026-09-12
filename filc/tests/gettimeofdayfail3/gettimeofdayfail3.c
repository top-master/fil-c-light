#include <sys/time.h>
#include <stdfil.h>
#include <stdlib.h>
#include <stddef.h>
#include <pizlonated_syscalls.h>

int main()
{
    // Test: insufficient buffer space for timeval* - pointer in bounds but not enough space
    char buf[20]; // 20 bytes, rounded to 32
    struct timeval* tv = (struct timeval*)(buf + 18); // Only 14 bytes left (32-18), need 16
    zsys_gettimeofday(tv, NULL);
    return 0;
}