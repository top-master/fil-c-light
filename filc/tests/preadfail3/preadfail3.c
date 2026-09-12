#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdfil.h>
#include <stdint.h>

int main() {
    int fd = open("filc/tests/preadfail3/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    // Integer cast to pointer - use an integer value as a pointer
    uintptr_t fake_ptr = 0x12345678;
    char* buf = (char*)fake_ptr;
    
    // This should fail because we're using an integer cast as a pointer
    ssize_t result = pread(fd, buf, 10, 0);
    
    if (result < 0) {
        perror("pread");
    } else {
        printf("pread unexpectedly succeeded with %zd bytes\n", result);
    }
    
    close(fd);
    return 0;
}