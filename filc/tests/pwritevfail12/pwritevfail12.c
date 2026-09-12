#include <unistd.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritevfail12/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    // Test 12: Integer cast iov_base
    struct iovec iov;
    iov.iov_base = (void*)42;
    iov.iov_len = 10;
    
    ssize_t result = pwritev(fd, &iov, 1, 0);
    zprintf("pwritev returned %ld\n", result);

    close(fd);
    return 0;
}