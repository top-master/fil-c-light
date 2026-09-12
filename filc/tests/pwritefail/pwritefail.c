#include <unistd.h>
#include <fcntl.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritefail/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    // Test 1: NULL pointer
    ssize_t result = pwrite(fd, NULL, 10, 0);
    zprintf("pwrite returned %ld\n", result);

    close(fd);
    return 0;
}