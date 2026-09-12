#include <stdfil.h>

int main(void)
{
    /* VZEROALL zeros all 256 bits of YMM0-YMM15. It performs no memory access
       and modifies no flags. Because it unconditionally writes ALL of
       YMM0-YMM15, every one of those registers must be declared as a clobber;
       with all of them clobbered no YMM operand may be used in the same asm, so
       this is a smoke test that verifies the instruction is permitted by the
       validator and executes. */
    asm volatile("vzeroall" :::
        "ymm0", "ymm1", "ymm2", "ymm3",
        "ymm4", "ymm5", "ymm6", "ymm7",
        "ymm8", "ymm9", "ymm10", "ymm11",
        "ymm12", "ymm13", "ymm14", "ymm15");
    return 0;
}
