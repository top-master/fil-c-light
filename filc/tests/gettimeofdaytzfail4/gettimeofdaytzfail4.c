#include <sys/time.h>
#include <stdfil.h>
#include <stdlib.h>
#include <stddef.h>
#include <pizlonated_syscalls.h>
#include "utils.h"

int main()
{
    // Test: use-after-free for timezone*
    struct timezone* tz = malloc(sizeof(struct timezone));
    free(opaque(tz));
    zsys_gettimeofday(NULL, tz);
    return 0;
}