#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/uio.h>

// Test 2: Integer cast iovec pointer
int main() {
    int fd = open("filc/tests/preadvfail2/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    char buffer[100];
    struct iovec *iov = (struct iovec*)0x1234;  // Integer cast pointer
    
    ssize_t result = preadv(fd, iov, 1, 0);
    
    close(fd);
    return 0;
}