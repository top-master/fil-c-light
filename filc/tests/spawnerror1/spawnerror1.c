#include <spawn.h>
#include <stdfil.h>
#include <stdlib.h>
#include <errno.h>

extern char** environ;

int main()
{
    int pid = 666;
    char* argv[] = { "e_c_h_o", NULL };
    int result = posix_spawn(&pid, "/e_c_h_o", NULL, NULL, argv, environ);
    ZASSERT(result == ENOENT);
    return 0;
}


