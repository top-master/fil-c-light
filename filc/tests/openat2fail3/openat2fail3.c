#include <fcntl.h>
#include <stdfil.h>
#include <stdlib.h>
#include <string.h>
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
    
    // pathname below bounds (before allocation)
    syscall(SYS_openat2, AT_FDCWD, p - 1000, &how, sizeof(how));
    return 0;
}
