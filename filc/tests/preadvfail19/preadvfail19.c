#include <unistd.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    int fd = open("filc/tests/preadvfail19/test.txt", O_RDONLY);
    ZASSERT(fd >= 0);

    // Test 19: Read-only buffer (string literal) - pread will try to write to it
    const char* readonly_str = "This is a read-only string literal";
    
    struct iovec iov;
    iov.iov_base = (void*)readonly_str;  // String literal is read-only from Fil-C's perspective
    iov.iov_len = 10;  // Smaller than string length to avoid length check
    
    ssize_t result = preadv(fd, &iov, 1, 0);
    zprintf("preadv returned %ld\n", result);

    close(fd);
    return 0;
}