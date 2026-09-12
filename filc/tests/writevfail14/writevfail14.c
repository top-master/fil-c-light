#include <unistd.h>
#include <stdfil.h>
#include <sys/uio.h>
#include <string.h>
#include <stdlib.h>
#include <inttypes.h>
#include "utils.h"

int main()
{
    int fds[2];
    ZASSERT(!pipe(fds));

    struct iovec iov[2];
    char buf1[20];
    strcpy(buf1, "first buffer");
    
    // First iovec is normal
    iov[0].iov_base = buf1;
    iov[0].iov_len = strlen(buf1);
    
    // Second iovec: evil integer overflow
    char* p = opaque(malloc(64));
    p -= (uintptr_t)p;  // Zero address
    p += UINTPTR_MAX - 20;  // Very high address
    
    iov[1].iov_base = p;
    iov[1].iov_len = 40;  // Should overflow when added to address

    writev(fds[1], iov, 2);
    return 0;
}