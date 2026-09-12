#include <unistd.h>
#include <stdfil.h>
#include <sys/uio.h>
#include <string.h>
#include <inttypes.h>

int main()
{
    int fds[2];
    ZASSERT(!pipe(fds));

    struct iovec iov[1];
    
    // Evil: integer cast to pointer in iovec
    iov[0].iov_base = (void*)0xDEADBEEFDEADBEEFUL;
    iov[0].iov_len = 25;

    writev(fds[1], iov, 1);
    return 0;
}