#include <stdlib.h>
#include <stdfil.h>
#include <errno.h>

int main()
{
    errno = 0;
    int result = system("e_c_h_o hello");
    ZASSERT(WIFEXITED(result));
    ZASSERT(WEXITSTATUS(result) == 127);
    return 0;
}

