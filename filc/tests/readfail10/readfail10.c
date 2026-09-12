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

    char buf[100];
    unsigned index;
    for (index = 100; index--;)
        buf[index] = (char)(index + 42);

    ZASSERT(write(fds[1], buf, 100) == 100);

    // Evil: integer overflow - pointer with valid capability but address that overflows
    char* p = opaque(malloc(16));
    p -= (uintptr_t)p;  // Zero out address, keep capability
    p += UINTPTR_MAX - 10;  // Near max address
    
    // This should overflow when syscall adds buffer length
    read(fds[0], p, 50);
    return 0;
}