#include <unistd.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <stdlib.h>
#include <string.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritevfail13/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    // Test 13: Freed iov_base
    char* data = malloc(20);
    strcpy(data, "hello world");
    
    struct iovec iov;
    iov.iov_base = data;
    iov.iov_len = strlen(data);
    
    free(data);
    ssize_t result = pwritev(fd, &iov, 1, 0);
    zprintf("pwritev returned %ld\n", result);

    close(fd);
    return 0;
}