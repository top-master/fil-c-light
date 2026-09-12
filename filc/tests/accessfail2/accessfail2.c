#include <unistd.h>
#include <stdfil.h>
#include <stdlib.h>

int main()
{
    access((char*)0x42424242, F_OK);
    return 0;
}