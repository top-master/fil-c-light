#include <unistd.h>
#include <stdfil.h>
#include <stdlib.h>
#include <stdint.h>

int main()
{
    uintptr_t addr = 0x12345678;
    char* p = (char*)addr;
    access(p, F_OK);
    return 0;
}