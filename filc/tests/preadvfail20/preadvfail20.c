#include <unistd.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <stdfil.h>
#include <stdlib.h>
#include <stdint.h>
#include "utils.h"

int main()
{
    int fd = open("filc/tests/preadvfail20/test.txt", O_RDONLY);
    ZASSERT(fd >= 0);

    // Test 20: Overflow buffer pointer using oobhigh pattern
    char* buffer = opaque(malloc(100));
    ZASSERT(buffer);
    
    // Make buffer pointer close to UINTPTR_MAX so that buffer + iov_len overflows
    char* p = buffer;
    p -= (uintptr_t)p;  // Make p = 0 (works because p is char*)
    p += 18446744073709551614lu;  // UINTPTR_MAX - 1
    buffer = opaque(p);
    
    struct iovec iov;
    iov.iov_base = buffer;
    iov.iov_len = 10;  // When preadv calculates buffer + 10, it will overflow
    
    ssize_t result = preadv(fd, &iov, 1, 0);
    zprintf("preadv returned %ld\n", result);

    close(fd);
    return 0;
}