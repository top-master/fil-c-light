#include <unistd.h>
#include <stdfil.h>
#include <sys/uio.h>
#include <string.h>
#include <inttypes.h>

int main()
{
    int fds[2];
    ZASSERT(!pipe(fds));

    char buf[100];
    strcpy(buf, "test data for readv");
    ZASSERT(write(fds[1], buf, strlen(buf)) == strlen(buf));

    struct iovec iov[1];
    
    // Evil: integer cast to pointer in iovec
    iov[0].iov_base = (void*)0x1337133713371337UL;
    iov[0].iov_len = 20;

    readv(fds[0], iov, 1);
    return 0;
}