#include <unistd.h>
#include <fcntl.h>
#include <stdfil.h>
#include <stdlib.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritefail6/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    // Test 6: Insufficient buffer (malloc(0))
    char* buf = malloc(0);
    ZASSERT(buf);

    ssize_t result = pwrite(fd, buf, 10, 0);
    zprintf("pwrite returned %ld\n", result);

    free(buf);
    close(fd);
    return 0;
}