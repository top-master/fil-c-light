#include <stdfil.h>

int main(void)
{
    /* sp may not be declared as a clobber (the "{sp}" constraint form is
       rejected by the frontend itself). */
    asm volatile("nop"
                 :
                 :
                 : "sp");
    zprintf("not reached\n");
    return 0;
}
