#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/uio.h>

// Test 12: Integer cast iov_base
int main() {
    int fd = open("filc/tests/preadvfail12/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    struct iovec iov;
    iov.iov_base = (void*)0x1234;  // Integer cast buffer
    iov.iov_len = 100;
    
    ssize_t result = preadv(fd, &iov, 1, 0);
    
    close(fd);
    return 0;
}