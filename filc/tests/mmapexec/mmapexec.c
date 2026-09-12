#include <unistd.h>
#include <stdio.h>
#include <sys/mman.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdfil.h>

struct foo {
    int x;
    char* y;
};

int main()
{
    struct foo* foo = mmap(
        0, sizeof(struct foo), PROT_WRITE | PROT_READ | PROT_EXEC, MAP_PRIVATE | MAP_ANON, -1, 0);
    ZASSERT(foo == (void*)(intptr_t)-1);
    ZASSERT(errno == EINVAL);
    return 0;
}

