#include <unistd.h>
#include <fcntl.h>
#include <stdfil.h>
#include <string.h>
#include <stdlib.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritefail9/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    // Test 9: Write non-terminated string
    const char* str = "hello world";
    size_t len = strlen(str);
    
    // Create a small buffer and try to write much more than it can hold
    char* buf = malloc(11);
    ZASSERT(buf);
    memcpy(buf, str, len);
    
    // Try to write much more than the buffer can hold
    ssize_t result = pwrite(fd, buf, 100, 0);
    
    free(buf);
    zprintf("pwrite returned %ld\n", result);

    close(fd);
    return 0;
}