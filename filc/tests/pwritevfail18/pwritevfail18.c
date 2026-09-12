#include <unistd.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritevfail18/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    // Test 18: Special object in iov_base
    // Using zweak_map_new() as a special object that shouldn't be treated as char buffer
    void* special_obj = zweak_map_new();
    ZASSERT(special_obj);
    
    struct iovec iov;
    iov.iov_base = special_obj;
    iov.iov_len = 10;
    
    ssize_t result = pwritev(fd, &iov, 1, 0);
    zprintf("pwritev returned %ld\n", result);

    close(fd);
    return 0;
}