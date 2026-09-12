#include <stdfil.h>

int main(void)
{
    asm volatile("cwd");
    return 0;
}
