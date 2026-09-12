#include <fcntl.h>
#include <stdfil.h>
#include <stdlib.h>
#include <sys/syscall.h>
#include <unistd.h>

struct open_how {
    unsigned long long flags;
    unsigned long long mode;
    unsigned long long resolve;
};

int main()
{
    // Special pointer (zweak_map_new) for how struct
    void* p = zweak_map_new();
    syscall(SYS_openat2, AT_FDCWD, "/test/path", (struct open_how*)p, sizeof(struct open_how));
    return 0;
}
