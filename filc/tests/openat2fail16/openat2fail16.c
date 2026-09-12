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
    // Integer cast to pointer (wild address) for how struct
    syscall(SYS_openat2, AT_FDCWD, "/test/path", (struct open_how*)0x1010101010101010UL, sizeof(struct open_how));
    return 0;
}
