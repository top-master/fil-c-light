#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/uio.h>

// Test 11: NULL iov_base
int main() {
    int fd = open("filc/tests/preadvfail11/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    struct iovec iov;
    iov.iov_base = NULL;  // NULL buffer
    iov.iov_len = 100;
    
    ssize_t result = preadv(fd, &iov, 1, 0);
    
    close(fd);
    return 0;
}