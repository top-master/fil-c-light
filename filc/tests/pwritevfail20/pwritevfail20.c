#include <unistd.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritevfail20/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    char* data = malloc(10);
    strcpy(data, "hello");
    
    // Test 20: Overflow iov_len
    // Set iov_len to a huge value that would cause overflow when added to the base pointer
    struct iovec iov;
    iov.iov_base = data;
    iov.iov_len = SIZE_MAX; // Maximum size_t value
    
    ssize_t result = pwritev(fd, &iov, 1, 0);
    zprintf("pwritev returned %ld\n", result);

    free(data);
    close(fd);
    return 0;
}