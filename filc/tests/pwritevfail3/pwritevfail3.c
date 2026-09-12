#include <unistd.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritevfail3/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    char data[] = "hello world";
    struct iovec* iov = malloc(sizeof(struct iovec));
    iov->iov_base = data;
    iov->iov_len = sizeof(data) - 1;
    
    // Test 3: Freed iovec pointer
    free(iov);
    ssize_t result = pwritev(fd, iov, 1, 0);
    zprintf("pwritev returned %ld\n", result);

    close(fd);
    return 0;
}