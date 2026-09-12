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

    char buf[100];
    strcpy(buf, "test data for readv overflow");
    ZASSERT(write(fds[1], buf, strlen(buf)) == strlen(buf));

    struct iovec iov[1];
    
    // Evil: integer overflow in iovec buffer
    char* p = opaque(malloc(32));
    p -= (uintptr_t)p;  // Zero address, preserve capability
    p += UINTPTR_MAX - 15;  // Close to max
    
    iov[0].iov_base = p;
    iov[0].iov_len = 30;  // This should overflow when checked

    readv(fds[0], iov, 1);
    return 0;
}