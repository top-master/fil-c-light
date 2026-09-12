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
    // Allocate small space for how struct but claim it's larger
    struct open_how* how = opaque(malloc(sizeof(struct open_how)));
    how->flags = O_RDONLY;
    how->mode = 0;
    how->resolve = 0;
    
    // Pass size that exceeds the actual allocation (claim 10 structs but only have 1)
    syscall(SYS_openat2, AT_FDCWD, "/test/path", how, sizeof(struct open_how) * 10);
    return 0;
}
