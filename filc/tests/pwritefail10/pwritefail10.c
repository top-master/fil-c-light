#include <unistd.h>
#include <fcntl.h>
#include <stdfil.h>
#include <stdint.h>
#include "utils.h"

int main()
{
    int fd = open("filc/test-output/pwritefail10/test.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    ZASSERT(fd >= 0);

    // Test 10: Overflow when adding length to pointer
    char buf[100];
    char* ptr = buf;
    
    // Create a pointer that will overflow when we add the length
    uintptr_t addr = (uintptr_t)ptr;
    uintptr_t evil_addr = UINTPTR_MAX - 5;
    uintptr_t diff = evil_addr - addr;
    
    ptr = ptr + diff;
    ptr = opaque(ptr);
    
    // This should overflow when checking ptr + 10
    ssize_t result = pwrite(fd, ptr, 10, 0);
    zprintf("pwrite returned %ld\n", result);

    close(fd);
    return 0;
}