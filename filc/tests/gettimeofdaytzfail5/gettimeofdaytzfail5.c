#include <sys/time.h>
#include <stdfil.h>
#include <stddef.h>
#include <pizlonated_syscalls.h>

int main()
{
    // Test: special object pointer for timezone*
    zsys_gettimeofday(NULL, zweak_map_new());
    return 0;
}