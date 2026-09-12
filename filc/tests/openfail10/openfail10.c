#include <fcntl.h>
#include <stdfil.h>
#include <stdlib.h>

int main()
{
    void* p = zweak_map_new();
    open(p, O_RDONLY);
    return 0;
}