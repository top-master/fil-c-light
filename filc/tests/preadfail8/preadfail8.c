#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdfil.h>

int main() {
    int fd = open("filc/tests/preadfail8/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    // Create a special object (zweak_map_new)
    char* special_obj = (char*)zweak_map_new();
    if (!special_obj) {
        close(fd);
        return 1;
    }
    
    // Try to read into a special object - this should fail
    ssize_t result = pread(fd, special_obj, 10, 0);
    
    if (result < 0) {
        perror("pread");
    } else {
        printf("pread unexpectedly succeeded with %zd bytes\n", result);
    }
    
    close(fd);
    return 0;
}