#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/uio.h>
#include <stdlib.h>

// Test 5: Above bounds iovec pointer
int main() {
    int fd = open("filc/tests/preadvfail5/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    char buffer[100];
    struct iovec *iov_array = malloc(sizeof(struct iovec) * 2);
    struct iovec *iov = iov_array + 10;  // Above bounds
    
    ssize_t result = preadv(fd, iov, 1, 0);
    
    free(iov_array);
    close(fd);
    return 0;
}