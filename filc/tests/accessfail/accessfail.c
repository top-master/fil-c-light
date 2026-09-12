#include <unistd.h>
#include <stdfil.h>
#include <stdlib.h>

int main()
{
    access(NULL, F_OK);
    return 0;
}