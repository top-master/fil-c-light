#include <unistd.h>
#include <stdfil.h>
#include <string.h>
#include <inttypes.h>

int main()
{
    int fds[2];
    ZASSERT(!pipe(fds));

    char buf[100];
    unsigned index;
    for (index = 100; index--;)
        buf[index] = (char)(index + 42);

    ZASSERT(write(fds[1], buf, 100) == 100);

    // Evil: integer cast to pointer - raw address
    read(fds[0], (void*)0x1010101010101010UL, 50);
    return 0;
}