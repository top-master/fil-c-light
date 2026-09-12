#include <stdfil.h>

int main(void)
{
    extern int some_external_function(void);
    asm volatile("bl some_external_function");
    zprintf("not reached\n");
    return 0;
}
