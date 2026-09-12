#include <sys/time.h>
#include <stdfil.h>
#include <inttypes.h>
#include <stddef.h>
#include <pizlonated_syscalls.h>

int main()
{
    // Test: integer cast to pointer for timezone*
    zsys_gettimeofday(NULL, (struct timezone*)0x1010101010101010UL);
    return 0;
}