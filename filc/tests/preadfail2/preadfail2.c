#include <unistd.h>
#include <fcntl.h>
#include <stdfil.h>
#include <stdlib.h>
#include "utils.h"

int main()
{
    int fd = open("filc/tests/preadfail2/test.txt", O_RDONLY);
    ZASSERT(fd >= 0);

    char* buf = malloc(100);
    ZASSERT(buf);

    // Test 2: Pointer above bounds
    ssize_t result = pread(fd, buf + 1000, 10, 0);
    zprintf("pread returned %ld\n", result);

    free(buf);
    close(fd);
    return 0;
}