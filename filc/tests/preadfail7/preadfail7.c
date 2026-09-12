#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdfil.h>

int main() {
    int fd = open("filc/tests/preadfail7/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    // Allocate buffer then free it
    char* buf = malloc(100);
    if (!buf) {
        close(fd);
        return 1;
    }
    
    free(buf);
    
    // Try to use the freed buffer - this should fail
    ssize_t result = pread(fd, buf, 10, 0);
    
    if (result < 0) {
        perror("pread");
    } else {
        printf("pread unexpectedly succeeded with %zd bytes\n", result);
    }
    
    close(fd);
    return 0;
}