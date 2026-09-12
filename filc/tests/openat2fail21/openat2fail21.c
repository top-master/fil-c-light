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
    
    // Allocate large buffer but don't null terminate within bounds
    char* p = opaque(malloc(1024));
    memset(p, 'a', 1024);  // Fill entire buffer with 'a', no null terminator
    
    // Pathname string read will go past allocation looking for null terminator
    syscall(SYS_openat2, AT_FDCWD, p, &how, sizeof(how));
    return 0;
}
