#include <unistd.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritevfail/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    char data[] = "hello world";

    // Test 1: NULL iovec pointer
    ssize_t result = pwritev(fd, NULL, 1, 0);
    zprintf("pwritev returned %ld\n", result);

    close(fd);
    return 0;
}