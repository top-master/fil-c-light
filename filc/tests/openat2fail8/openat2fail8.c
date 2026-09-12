#include <fcntl.h>
#include <stdfil.h>
#include <stdlib.h>
#include <stdint.h>
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
    
    // Integer cast to pointer (wild address) for pathname
    syscall(SYS_openat2, AT_FDCWD, (char*)0x1010101010101010UL, &how, sizeof(how));
    return 0;
}
