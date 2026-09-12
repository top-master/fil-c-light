#include <stdfil.h>
#include <stdlib.h>
#include "utils.h"
#include <string.h>

static const size_t size = 0x80000000;

int main()
{
    char* buf1 = malloc(size);
    memset(buf1, 42, size);
    char* buf2 = malloc(size);
    memcpy(buf2, buf1, size);
    ZASSERT(!memcmp(opaque(buf1), opaque(buf2), size));
    return 0;
}

