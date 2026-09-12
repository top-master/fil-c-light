#include <unistd.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritevfail7/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    char data[] = "hello world";
    
    // Test 7: malloc(0) iovec array
    struct iovec* iov = malloc(0);
    
    ssize_t result = pwritev(fd, iov, 1, 0);
    zprintf("pwritev returned %ld\n", result);

    free(iov);
    close(fd);
    return 0;
}