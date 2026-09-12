#include <stdfil.h>

int main(void)
{
    /* UD2 is the canonical "unreachable" trap instruction. It raises SIGILL,
       which Fil-C does not allow to be caught, so it is safe. We place it in a
       dead branch (guarded by a volatile flag) so that Fil-C validates and
       accepts the instruction, but it is never actually executed at runtime. */
    volatile int flag = 0;
    if (flag) {
        asm volatile("ud2");
    }
    ZASSERT(!flag);
    return 0;
}
