#include <stdlib.h>
#include <stdfil.h>
#include <stdio.h>
#include <string.h>
#include <filc_test_support.h>
#include <unistd.h>

int main()
{
    unsigned n;
    for (n = 10000; n--;)
        ZASSERT(!system("echo hello"));
    return 0;
}
