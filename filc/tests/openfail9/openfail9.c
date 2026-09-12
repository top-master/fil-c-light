#include <fcntl.h>
#include <stdfil.h>
#include <stdlib.h>
#include <string.h>

int main()
{
    char* p = malloc(64);
    strcpy(p, "filc/tests/openfail9/test.txt");
    free(p);
    open(p, O_RDONLY);  // Use after free
    return 0;
}