#include <unistd.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <stdfil.h>
#include <stdlib.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritevfail9/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    char data[] = "hello world";
    
    // Test 9: Try to write from a string literal (read-only from Fil-C's perspective)
    const char* readonly_str = "This is a read-only string literal";
    
    struct iovec iov;
    iov.iov_base = (void*)readonly_str;
    iov.iov_len = 10;  // Less than string length to avoid length issues
    
    ssize_t result = pwritev(fd, &iov, 1, 0);
    zprintf("pwritev returned %ld\n", result);

    close(fd);
    return 0;
}