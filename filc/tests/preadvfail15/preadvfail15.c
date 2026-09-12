#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/uio.h>
#include <stdlib.h>

// Test 15: Above bounds iov_base
int main() {
    int fd = open("filc/tests/preadvfail15/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    char *buffer = malloc(100);
    struct iovec iov;
    iov.iov_base = buffer + 200;  // Above bounds
    iov.iov_len = 100;
    
    ssize_t result = preadv(fd, &iov, 1, 0);
    
    free(buffer);
    close(fd);
    return 0;
}