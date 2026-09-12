#include <unistd.h>
#include <fcntl.h>
#include <stdfil.h>
#include <stdlib.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritefail3/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    // Test 3: Integer cast to pointer
    void* buf = (void*)0xdeadbeefdeadbeefUL;
    buf = opaque(buf);
    
    ssize_t result = pwrite(fd, buf, 10, 0);
    zprintf("pwrite returned %ld\n", result);

    close(fd);
    return 0;
}