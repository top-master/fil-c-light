#include <unistd.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritevfail8/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    // Test 8: Special object iovec
    // Using zweak_map_new() as a special object that shouldn't be treated as struct iovec array
    void* special_obj = zweak_map_new();
    ZASSERT(special_obj);
    struct iovec* iov = (struct iovec*)special_obj;
    
    ssize_t result = pwritev(fd, iov, 1, 0);
    zprintf("pwritev returned %ld\n", result);

    close(fd);
    return 0;
}