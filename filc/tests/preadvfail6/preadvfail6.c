#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/uio.h>
#include <stdlib.h>

// Test 6: Insufficient iovec array space
int main() {
    int fd = open("filc/tests/preadvfail6/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    char buffer[100];
    struct iovec *iov = malloc(sizeof(struct iovec));  // Space for 1 iovec
    iov->iov_base = buffer;
    iov->iov_len = sizeof(buffer);
    
    ssize_t result = preadv(fd, iov, 2, 0);  // Try to read 2 iovecs but only have space for 1
    
    free(iov);
    close(fd);
    return 0;
}