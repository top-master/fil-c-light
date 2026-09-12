#include <stdfil.h>

int main(void)
{
    /* cld clears the direction flag. We just need to verify that the
       instruction is accepted and executes without crashing. */
    asm volatile("cld" ::: "dirflag");
    return 0;
}
