#include <unistd.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <stdfil.h>
#include <stdlib.h>
#include "utils.h"

int main()
{
    int fd = open("filc/tests/preadvfail9/test.txt", O_RDONLY);
    ZASSERT(fd >= 0);

    char buffer[100];
    
    // Test 9: iovec array bounds violation - create small array but use large iovcnt
    struct iovec* iov = malloc(sizeof(struct iovec) * 1);  // Space for only 1 iovec
    ZASSERT(iov);
    
    iov[0].iov_base = buffer;
    iov[0].iov_len = 10;
    
    // Pass iovcnt=100 but we only allocated space for 1 iovec - this should fail
    ssize_t result = preadv(fd, iov, 100, 0);
    zprintf("preadv returned %ld\n", result);

    free(iov);
    close(fd);
    return 0;
}