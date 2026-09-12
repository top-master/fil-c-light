#include <sys/socket.h>
#include <stdfil.h>
#include <stdlib.h>

int main()
{
    int socks[2];
    ZASSERT(!socketpair(AF_UNIX, SOCK_STREAM, 0, socks));

    sendto(socks[0], NULL, 100, 0, NULL, 0);
    return 0;
}