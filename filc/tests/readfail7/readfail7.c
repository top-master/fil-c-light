#include <unistd.h>
#include <stdfil.h>
#include <string.h>
#include <stdlib.h>
#include "utils.h"

int main()
{
    int fds[2];
    ZASSERT(!pipe(fds));

    char* buf = malloc(100);
    unsigned index;
    for (index = 100; index--;)
        buf[index] = (char)(index + 666);

    ZASSERT(write(fds[1], buf, 100) == 100);

    free(opaque(buf));
    read(fds[0], buf, 100);
    return 0;
}

