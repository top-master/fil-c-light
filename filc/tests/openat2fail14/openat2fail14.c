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
    struct open_how* how = opaque(malloc(sizeof(struct open_how)));
    how->flags = O_RDONLY;
    how->mode = 0;
    how->resolve = 0;
    
    // Create a pointer that will overflow when adding size
    // Subtract the pointer's value to get near zero, then go near max address
    how = (struct open_how*)((uintptr_t)how - (uintptr_t)how);
    how = (struct open_how*)((uintptr_t)how + UINTPTR_MAX - 10);
    
    syscall(SYS_openat2, AT_FDCWD, "/test/path", how, sizeof(struct open_how));
    return 0;
}
