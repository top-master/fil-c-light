#include <unistd.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritevfail6/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    char data[] = "hello world";
    
    // Test 6: Insufficient iovec array space
    // Allocate space for 1 iovec but try to use 2
    struct iovec* iov = malloc(sizeof(struct iovec));
    iov[0].iov_base = data;
    iov[0].iov_len = sizeof(data) - 1;
    
    ssize_t result = pwritev(fd, iov, 2, 0); // Requesting 2 iovecs but only allocated 1
    zprintf("pwritev returned %ld\n", result);

    free(iov);
    close(fd);
    return 0;
}