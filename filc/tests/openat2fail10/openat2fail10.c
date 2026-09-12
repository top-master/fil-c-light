#include <fcntl.h>
#include <stdfil.h>
#include <stdlib.h>
#include <string.h>
#include <sys/syscall.h>
#include <unistd.h>

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
    
    // String not null-terminated - allocate and fill with non-null characters
    char* p = malloc(16);
    memset(p, 'x', 16);  // Fill entire buffer with 'x', no null terminator
    
    syscall(SYS_openat2, AT_FDCWD, p, &how, sizeof(how));
    return 0;
}
