#include <fcntl.h>
#include <stdfil.h>
#include <stdlib.h>

int main()
{
    open(NULL, O_RDONLY);
    return 0;
}