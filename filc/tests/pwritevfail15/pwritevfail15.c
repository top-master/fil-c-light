#include <unistd.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <stdlib.h>
#include <string.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritevfail15/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    // Test 15: Above bounds iov_base
    char* data = malloc(20);  // malloc(20) rounds up to 32 bytes
    strcpy(data, "hello world");
    
    struct iovec iov;
    iov.iov_base = data + 33; // Past the end of the 32-byte buffer
    iov.iov_len = 10;
    
    ssize_t result = pwritev(fd, &iov, 1, 0);
    zprintf("pwritev returned %ld\n", result);

    free(data);
    close(fd);
    return 0;
}