#include <unistd.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritevfail17/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    // Test 17: malloc(0) buffer in iov_base
    char* data = malloc(0);
    
    struct iovec iov;
    iov.iov_base = data;
    iov.iov_len = 1; // Trying to read 1 byte from malloc(0) buffer
    
    ssize_t result = pwritev(fd, &iov, 1, 0);
    zprintf("pwritev returned %ld\n", result);

    free(data);
    close(fd);
    return 0;
}