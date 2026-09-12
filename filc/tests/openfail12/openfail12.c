#include <fcntl.h>
#include <stdfil.h>
#include <stdlib.h>
#include <string.h>

int main()
{
    char* p = malloc(16);  // 16-byte buffer
    memset(p, 'x', 16);    // Fill entire buffer with 'x', no null terminator
    
    // This should fail when open() tries to find the null terminator
    open(p, O_RDONLY);
    return 0;
}