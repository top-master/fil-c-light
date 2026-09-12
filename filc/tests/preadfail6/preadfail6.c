#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdfil.h>

int main() {
    int fd = open("filc/tests/preadfail6/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    // malloc(0) returns a valid pointer but with zero size
    char* buf = malloc(0);
    if (!buf) {
        close(fd);
        return 1;
    }
    
    // Try to read any bytes into a zero-size buffer
    ssize_t result = pread(fd, buf, 10, 0);
    
    if (result < 0) {
        perror("pread");
    } else {
        printf("pread unexpectedly succeeded with %zd bytes\n", result);
    }
    
    free(buf);
    close(fd);
    return 0;
}