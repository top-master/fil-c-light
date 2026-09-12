#include <unistd.h>
#include <stdfil.h>
#include <stdlib.h>
#include <string.h>
#include "utils.h"

int main()
{
    char* p = malloc(16);
    strcpy(p, "test");
    free(p);
    access(opaque(p), F_OK);
    return 0;
}