#include <unistd.h>
#include <stdfil.h>
#include <stdlib.h>

int main()
{
    void* p = zweak_map_new();
    access((char*)p, F_OK);
    return 0;
}