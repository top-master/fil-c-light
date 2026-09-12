#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdfil.h>

int main() {
    int fd = open("filc/tests/preadfail4/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    // Allocate buffer but use pointer below bounds
    char* buf = malloc(100);
    if (!buf) {
        close(fd);
        return 1;
    }
    
    // Point to memory before the allocated buffer
    char* bad_ptr = buf - 10;
    
    // This should fail because bad_ptr is below the bounds of the allocation
    ssize_t result = pread(fd, bad_ptr, 10, 0);
    
    if (result < 0) {
        perror("pread");
    } else {
        printf("pread unexpectedly succeeded with %zd bytes\n", result);
    }
    
    free(buf);
    close(fd);
    return 0;
}