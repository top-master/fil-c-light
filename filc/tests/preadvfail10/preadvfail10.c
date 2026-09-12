#include <unistd.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <stdfil.h>
#include <stdlib.h>
#include <stdint.h>
#include "utils.h"

int main()
{
    int fd = open("filc/tests/preadvfail10/test.txt", O_RDONLY);
    ZASSERT(fd >= 0);

    // Test 10: Overflow iovec pointer using pattern from oobhigh1.c
    struct iovec* iov = opaque(malloc(sizeof(struct iovec)));
    ZASSERT(iov);
    
    // Make pointer close to UINTPTR_MAX so that iov + iovcnt * sizeof(struct iovec) overflows
    char* p = (char*)iov;
    p -= (uintptr_t)p;  // Make p = 0 (works because p is char*)
    p += 18446744073709551614lu;  // UINTPTR_MAX - 1
    iov = (struct iovec*)opaque(p);
    
    // When preadv calculates iov + 1 * sizeof(struct iovec), it will overflow
    ssize_t result = preadv(fd, iov, 1, 0);
    zprintf("preadv returned %ld\n", result);

    close(fd);
    return 0;
}