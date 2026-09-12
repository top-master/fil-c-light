#include <unistd.h>
#include <stdfil.h>
#include <string.h>
#include <stdlib.h>

int main()
{
    int fds[2];
    ZASSERT(!pipe(fds));

    // Create a small buffer that will definitely be out of bounds for a large write
    // Using malloc to avoid potential stack allocation padding
    char* buf = malloc(32);
    unsigned index;
    for (index = 32; index--;)
        buf[index] = (char)(index + 42);

    // Try to write 1000 bytes from a 32-byte buffer - this should fail
    write(fds[1], buf, 1000);
    return 0;
}