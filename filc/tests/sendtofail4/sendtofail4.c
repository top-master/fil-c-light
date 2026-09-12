#include <sys/socket.h>
#include <stdfil.h>
#include <string.h>
#include <stdlib.h>

int main()
{
    int socks[2];
    ZASSERT(!socketpair(AF_UNIX, SOCK_STREAM, 0, socks));

    char* p = malloc(100);
    sendto(socks[0], p - 1000, 50, 0, NULL, 0);
    return 0;
}