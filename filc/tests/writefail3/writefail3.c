#include <unistd.h>
#include <stdfil.h>
#include <string.h>

int main()
{
    int fds[2];
    ZASSERT(!pipe(fds));

    char buf[100];
    unsigned index;
    for (index = 100; index--;)
        buf[index] = (char)(index + 42);

    ZASSERT(write(fds[1], buf, 100) == 100);
    
    char readbuf[100];
    ZASSERT(read(fds[0], readbuf, 100) == 100);
    
    for (index = 100; index--;) {
        ZASSERT(readbuf[index] == (char)(index + 42));
    }
    
    return 0;
}