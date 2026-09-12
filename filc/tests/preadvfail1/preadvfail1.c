#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/uio.h>

// Test 1: NULL iovec pointer
int main() {
    int fd = open("filc/tests/preadvfail1/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    char buffer[100];
    struct iovec *iov = NULL;  // NULL pointer
    
    ssize_t result = preadv(fd, iov, 1, 0);
    
    close(fd);
    return 0;
}