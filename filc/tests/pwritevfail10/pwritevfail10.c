#include <unistd.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritevfail10/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    char data[] = "hello world";
    
    // Test 10: Overflow iovec pointer
    // Create a pointer that will overflow when accessing array elements
    struct iovec* iov = (struct iovec*)(UINTPTR_MAX - sizeof(struct iovec) + 1);
    
    ssize_t result = pwritev(fd, iov, 2, 0); // This should cause overflow when calculating iov[1]
    zprintf("pwritev returned %ld\n", result);

    close(fd);
    return 0;
}