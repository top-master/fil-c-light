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
    struct open_how* how = malloc(sizeof(struct open_how));
    how->flags = O_RDONLY;
    how->mode = 0;
    how->resolve = 0;
    
    free(how);
    
    // Use after free for how struct
    syscall(SYS_openat2, AT_FDCWD, "/test/path", how, sizeof(struct open_how));
    return 0;
}
