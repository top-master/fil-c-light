#include <sys/socket.h>
#include <stdfil.h>
#include <string.h>
#include <inttypes.h>

int main()
{
    int socks[2];
    ZASSERT(!socketpair(AF_UNIX, SOCK_STREAM, 0, socks));

    sendto(socks[0], (void*)0x1010101010101010UL, 50, 0, NULL, 0);
    return 0;
}