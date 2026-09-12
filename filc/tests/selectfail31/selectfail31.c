#include <sys/select.h>
#include <stdfil.h>
#include <stdlib.h>
#include <inttypes.h>
#include "utils.h"

int main()
{
    // Create pointer with valid capability but address that will overflow
    struct timeval* timeout = opaque(malloc(sizeof(struct timeval)));
    timeout = (struct timeval*)((char*)timeout - (uintptr_t)timeout);  // Zero out address, keep capability
    timeout = (struct timeval*)((char*)timeout + UINTPTR_MAX - 10);   // Near max address
    
    // This should overflow when syscall validates the timeval buffer
    select(0, NULL, NULL, NULL, timeout);
    
    return 0;
}
