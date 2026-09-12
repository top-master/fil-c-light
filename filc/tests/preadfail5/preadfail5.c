#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdfil.h>

int main() {
    int fd = open("filc/tests/preadfail5/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    // Allocate a small buffer
    char* buf = malloc(5);
    if (!buf) {
        close(fd);
        return 1;
    }
    
    // Try to read more bytes than the buffer can hold
    ssize_t result = pread(fd, buf, 20, 0);
    
    if (result < 0) {
        perror("pread");
    } else {
        printf("pread unexpectedly succeeded with %zd bytes\n", result);
    }
    
    free(buf);
    close(fd);
    return 0;
}