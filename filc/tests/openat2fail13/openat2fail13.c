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
    // Allocate space for 1 struct open_how, but tell openat2 we have space for 100
    struct open_how* how = opaque(malloc(sizeof(struct open_how)));
    how->flags = O_RDONLY;
    how->mode = 0;
    how->resolve = 0;
    
    // In bounds but size bigger than allocation (sizeof * 100)
    syscall(SYS_openat2, AT_FDCWD, "/test/path", how, sizeof(struct open_how) * 100);
    return 0;
}
