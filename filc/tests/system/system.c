#include <stdlib.h>
#include <stdfil.h>
#include <errno.h>

int main()
{
    errno = 0;
    ZASSERT(!system("echo hello"));
    ZASSERT(!errno);
    return 0;
}

