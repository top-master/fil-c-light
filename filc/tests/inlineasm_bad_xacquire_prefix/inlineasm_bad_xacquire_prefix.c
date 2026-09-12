#include <stdfil.h>

int main(void)
{
    asm volatile("xacquire");
    return 0;
}
