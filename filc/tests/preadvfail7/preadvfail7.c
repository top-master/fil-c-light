#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/uio.h>
#include <stdlib.h>

// Test 7: malloc(0) iovec array
int main() {
    int fd = open("filc/tests/preadvfail7/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    char buffer[100];
    struct iovec *iov = malloc(0);  // Zero-sized allocation
    
    ssize_t result = preadv(fd, iov, 1, 0);
    
    if (iov) free(iov);
    close(fd);
    return 0;
}