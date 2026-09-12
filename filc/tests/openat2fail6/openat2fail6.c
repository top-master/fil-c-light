#include <fcntl.h>
#include <stdfil.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <sys/syscall.h>
#include <unistd.h>
#include "utils.h"

struct open_how {
    unsigned long long flags;
    unsigned long long mode;
    unsigned long long resolve;
};

int main()
{
    struct open_how how;
    how.flags = O_RDONLY;
    how.mode = 0;
    how.resolve = 0;
    
    char* p = opaque(malloc(16));
    strcpy(p, "test.txt");
    
    // Create a pointer that will overflow when calculating string length
    // Subtract the pointer's value to get near zero, then go near max address
    p = (char*)((uintptr_t)p - (uintptr_t)p);
    p += UINTPTR_MAX - 10;
    
    syscall(SYS_openat2, AT_FDCWD, p, &how, sizeof(how));
    return 0;
}
