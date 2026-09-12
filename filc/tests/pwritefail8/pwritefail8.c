#include <unistd.h>
#include <fcntl.h>
#include <stdfil.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritefail8/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    // Test 8: Special object
    void* buf = zweak_map_new();
    ZASSERT(buf);

    ssize_t result = pwrite(fd, buf, 10, 0);
    zprintf("pwrite returned %ld\n", result);

    close(fd);
    return 0;
}