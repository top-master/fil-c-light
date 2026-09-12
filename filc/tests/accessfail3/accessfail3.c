#include <unistd.h>
#include <stdfil.h>
#include <stdlib.h>
#include "utils.h"

int main()
{
    char* p = malloc(16);
    access(opaque(p + 1000), F_OK);
    return 0;
}