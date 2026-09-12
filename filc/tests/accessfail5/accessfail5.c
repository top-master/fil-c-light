#include <unistd.h>
#include <stdfil.h>
#include <stdlib.h>
#include <stdint.h>
#include "utils.h"

int main()
{
    char* p = malloc(16);
    uintptr_t addr = (uintptr_t)p;
    char* bad = (char*)(addr + UINTPTR_MAX - 100);
    access(opaque(bad), F_OK);
    return 0;
}