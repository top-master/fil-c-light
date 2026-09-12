#include <unistd.h>
#include <stdfil.h>
#include <string.h>
#include <stdlib.h>
#include <inttypes.h>
#include "utils.h"

int main()
{
    int fds[2];
    ZASSERT(!pipe(fds));

    // Evil: integer overflow attack on write
    char* p = opaque(malloc(16));
    p -= (uintptr_t)p;  // Zero address, keep capability 
    p += UINTPTR_MAX - 5;  // Very high address
    
    // When syscall computes p + 50, it should overflow
    write(fds[1], p, 50);
    return 0;
}