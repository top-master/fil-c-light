#include <fcntl.h>
#include <stdfil.h>
#include <stdlib.h>
#include <inttypes.h>

int main()
{
    open((char*)0x1010101010101010UL, O_RDONLY);
    return 0;
}