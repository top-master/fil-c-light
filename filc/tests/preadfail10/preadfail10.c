#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdfil.h>

int main() {
    int fd = open("filc/tests/preadfail10/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    // Allocate a buffer
    char* buf = malloc(100);
    if (!buf) {
        close(fd);
        return 1;
    }
    
    // Use a pointer near the end of the buffer and a large length that would overflow
    char* near_end = buf + 90;
    size_t huge_length = SIZE_MAX - 50;  // This will cause overflow when added to pointer
    
    // This should fail because pointer + length overflows
    ssize_t result = pread(fd, near_end, huge_length, 0);
    
    if (result < 0) {
        perror("pread");
    } else {
        printf("pread unexpectedly succeeded with %zd bytes\n", result);
    }
    
    free(buf);
    close(fd);
    return 0;
}