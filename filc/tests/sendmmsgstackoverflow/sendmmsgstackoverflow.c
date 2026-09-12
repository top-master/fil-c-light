#define _GNU_SOURCE
#include <sys/socket.h>
#include <stdlib.h>

int main()
{
    size_t huge = 10000000;
    struct mmsghdr* vec = malloc(huge * sizeof(struct mmsghdr));
    sendmmsg(0, vec, huge, 0);
    return 0;
}

