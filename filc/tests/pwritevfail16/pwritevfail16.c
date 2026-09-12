#include <unistd.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <stdlib.h>
#include <string.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritevfail16/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    // Test 16: Insufficient buffer in iov_base
    char* data = malloc(1);  // malloc(1) rounds up to 16 bytes
    *data = 'x'; // Put some data in it
    
    struct iovec iov;
    iov.iov_base = data;
    iov.iov_len = 1000; // Requesting to read 1000 bytes from buffer (much bigger than 16)
    
    ssize_t result = pwritev(fd, &iov, 1, 0);
    zprintf("pwritev returned %ld\n", result);

    free(data);
    close(fd);
    return 0;
}