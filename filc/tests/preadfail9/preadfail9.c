#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdfil.h>

int main() {
    int fd = open("filc/tests/preadfail9/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    // Use a string literal (read-only object)
    char* readonly_buf = "This is a read-only string literal";
    
    // Try to read into a read-only string literal - this should fail
    ssize_t result = pread(fd, readonly_buf, 10, 0);
    
    if (result < 0) {
        perror("pread");
    } else {
        printf("pread unexpectedly succeeded with %zd bytes\n", result);
    }
    
    close(fd);
    return 0;
}