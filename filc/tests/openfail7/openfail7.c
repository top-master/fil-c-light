#include <fcntl.h>
#include <stdfil.h>
#include <stdlib.h>

int main()
{
    // O_CREAT requires mode argument but we're not providing it
    open("filc/test-output/openfail7/test.txt", O_CREAT | O_WRONLY);
    return 0;
}