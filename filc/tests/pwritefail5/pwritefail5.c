#include <unistd.h>
#include <fcntl.h>
#include <stdfil.h>
#include <stdlib.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritefail5/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    char* buf = malloc(100);
    ZASSERT(buf);

    // Test 5: Insufficient buffer for length provided
    ssize_t result = pwrite(fd, buf + 50, 100, 0);
    zprintf("pwrite returned %ld\n", result);

    free(buf);
    close(fd);
    return 0;
}