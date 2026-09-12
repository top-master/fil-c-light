#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/uio.h>
#include <stdlib.h>

// Test 17: malloc(0) buffer in iov_base
int main() {
    int fd = open("filc/tests/preadvfail17/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    char *buffer = malloc(0);  // Zero-sized buffer
    struct iovec iov;
    iov.iov_base = buffer;
    iov.iov_len = 100;
    
    ssize_t result = preadv(fd, &iov, 1, 0);
    
    if (buffer) free(buffer);
    close(fd);
    return 0;
}