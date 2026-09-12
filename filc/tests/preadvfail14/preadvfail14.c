#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/uio.h>
#include <stdlib.h>

// Test 14: Below bounds iov_base
int main() {
    int fd = open("filc/tests/preadvfail14/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    char *buffer = malloc(100);
    struct iovec iov;
    iov.iov_base = buffer - 10;  // Below bounds
    iov.iov_len = 100;
    
    ssize_t result = preadv(fd, &iov, 1, 0);
    
    free(buffer);
    close(fd);
    return 0;
}