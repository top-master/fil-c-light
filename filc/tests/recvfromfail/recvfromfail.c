#include <sys/socket.h>
#include <stdfil.h>
#include <stdlib.h>

int main()
{
    int socks[2];
    ZASSERT(!socketpair(AF_UNIX, SOCK_STREAM, 0, socks));

    char buf[100];
    ZASSERT(send(socks[0], buf, 100, 0) == 100);

    recvfrom(socks[1], NULL, 100, 0, NULL, NULL);
    return 0;
}