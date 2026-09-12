#include <unistd.h>
#include <fcntl.h>
#include <stdfil.h>
#include <stdlib.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritefail2/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    char* buf = malloc(100);
    ZASSERT(buf);

    // Test 2: Pointer above bounds
    ssize_t result = pwrite(fd, buf + 1000, 10, 0);
    zprintf("pwrite returned %ld\n", result);

    free(buf);
    close(fd);
    return 0;
}