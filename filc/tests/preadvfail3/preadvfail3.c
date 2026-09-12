#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/uio.h>
#include <stdlib.h>

// Test 3: Freed iovec pointer
int main() {
    int fd = open("filc/tests/preadvfail3/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    char buffer[100];
    struct iovec *iov = malloc(sizeof(struct iovec));
    iov->iov_base = buffer;
    iov->iov_len = sizeof(buffer);
    
    free(iov);  // Free the iovec
    
    ssize_t result = preadv(fd, iov, 1, 0);  // Use after free
    
    close(fd);
    return 0;
}