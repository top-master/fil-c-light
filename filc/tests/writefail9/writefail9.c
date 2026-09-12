#include <unistd.h>
#include <stdfil.h>
#include <string.h>
#include <inttypes.h>

int main()
{
    int fds[2];
    ZASSERT(!pipe(fds));

    // Evil: integer cast to pointer - raw address
    write(fds[1], (void*)0x4242424242424242UL, 50);
    return 0;
}