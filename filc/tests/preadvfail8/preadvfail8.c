#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/uio.h>
#include <stdfil.h>

// Test 8: Special object iovec (using zweak_map_new)
int main() {
    int fd = open("filc/tests/preadvfail8/test.txt", O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 1;
    }
    
    // Create a special object using zweak_map_new()
    void* special_obj = zweak_map_new();
    if (!special_obj) {
        close(fd);
        return 1;
    }
    struct iovec *iov = (struct iovec*)special_obj;
    
    ssize_t result = preadv(fd, iov, 1, 0);
    
    close(fd);
    return 0;
}