#include <unistd.h>
#include <fcntl.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    int fd = open("filc/tests/preadfail/test.txt", O_RDONLY);
    ZASSERT(fd >= 0);

    // Test 1: NULL pointer
    ssize_t result = pread(fd, NULL, 10, 0);
    zprintf("pread returned %ld\n", result);

    close(fd);
    return 0;
}