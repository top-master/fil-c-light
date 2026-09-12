#include <sys/time.h>
#include <stdfil.h>
#include <stddef.h>
#include <pizlonated_syscalls.h>

int main()
{
    // Both pointers NULL - should succeed
    int result = zsys_gettimeofday(NULL, NULL);
    ZASSERT(result == 0);
    return 0;
}