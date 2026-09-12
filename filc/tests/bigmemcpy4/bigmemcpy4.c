#include <stdfil.h>
#include <stdlib.h>
#include "utils.h"
#include <string.h>

static const size_t size = 0xffffffff;

int main()
{
    char* buf1 = malloc(64);
    memset(buf1, 42, 64);
    char* buf2 = malloc(size);
    memcpy(buf2, buf1, size);
    ZASSERT(!memcmp(opaque(buf1), opaque(buf2), 64));
    return 0;
}

