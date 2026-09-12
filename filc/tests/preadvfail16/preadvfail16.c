#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/uio.h>
#include <stdlib.h>

// Test 16: Insufficient buffer in iov_base
int main() {
    int fd = open("filc/tests/preadvfail16/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    char *buffer = malloc(50);  // Allocate 50 bytes
    struct iovec iov;
    iov.iov_base = buffer;
    iov.iov_len = 100;  // But try to read 100 bytes
    
    ssize_t result = preadv(fd, &iov, 1, 0);
    
    free(buffer);
    close(fd);
    return 0;
}