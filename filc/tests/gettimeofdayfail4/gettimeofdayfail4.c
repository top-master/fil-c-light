#include <sys/time.h>
#include <stdfil.h>
#include <stdlib.h>
#include <stddef.h>
#include <pizlonated_syscalls.h>
#include "utils.h"

int main()
{
    // Test: use-after-free for timeval*
    struct timeval* tv = malloc(sizeof(struct timeval));
    free(opaque(tv));
    zsys_gettimeofday(tv, NULL);
    return 0;
}