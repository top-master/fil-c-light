#include <sys/socket.h>
#include <stdfil.h>
#include <string.h>
#include <stdlib.h>

int main()
{
    int socks[2];
    ZASSERT(!socketpair(AF_UNIX, SOCK_STREAM, 0, socks));

    char buf[100];
    unsigned index;
    for (index = 100; index--;)
        buf[index] = (char)(index + 42);

    ZASSERT(send(socks[0], buf, 100, 0) == 100);

    char* p = malloc(16);
    recvfrom(socks[1], p, 1000, 0, NULL, NULL);
    return 0;
}