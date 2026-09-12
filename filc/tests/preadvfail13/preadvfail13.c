#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/uio.h>
#include <stdlib.h>

// Test 13: Freed iov_base
int main() {
    int fd = open("filc/tests/preadvfail13/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    char *buffer = malloc(100);
    struct iovec iov;
    iov.iov_base = buffer;
    iov.iov_len = 100;
    
    free(buffer);  // Free the buffer
    
    ssize_t result = preadv(fd, &iov, 1, 0);  // Use after free
    
    close(fd);
    return 0;
}