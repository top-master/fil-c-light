#include <sys/time.h>
#include <stdfil.h>
#include <stdlib.h>
#include <stddef.h>
#include <pizlonated_syscalls.h>

int main()
{
    // Test: insufficient buffer space for timezone* - pointer in bounds but not enough space
    char buf[12]; // 12 bytes, rounded to 16
    struct timezone* tz = (struct timezone*)(buf + 10); // Only 6 bytes left (16-10), need 8
    zsys_gettimeofday(NULL, tz);
    return 0;
}