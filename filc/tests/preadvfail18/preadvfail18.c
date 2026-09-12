#include <unistd.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    int fd = open("filc/tests/preadvfail18/test.txt", O_RDONLY);
    ZASSERT(fd >= 0);

    // Test 18: Special object in iov_base
    void* special_obj = zweak_map_new();
    ZASSERT(special_obj);

    struct iovec iov;
    iov.iov_base = special_obj;
    iov.iov_len = 10;

    ssize_t result = preadv(fd, &iov, 1, 0);
    zprintf("preadv returned %ld\n", result);

    close(fd);
    return 0;
}