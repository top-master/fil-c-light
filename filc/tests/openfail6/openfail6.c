#include <fcntl.h>
#include <stdfil.h>
#include <stdlib.h>
#include <string.h>

int main()
{
    char* p = malloc(16);
    memset(p, 'x', 16);  // Fill with non-null characters, no terminator
    open(p, O_RDONLY);
    return 0;
}