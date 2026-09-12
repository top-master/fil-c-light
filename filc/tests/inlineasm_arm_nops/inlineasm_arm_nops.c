#include <stdfil.h>

int main(void)
{
    asm volatile("nop");
    asm volatile("hint #0");
    asm volatile("bti c");
    asm volatile("bti j");
    asm volatile("bti jc");
    asm volatile("yield");
    asm volatile("sev");
    asm volatile("sevl");
    asm volatile("csdb");
    /* hint #16 is esb. (hint #8 used to be here, but hint #8 is an alias
       of pacia1716, which writes x17 - the validator now allowlists only
       the hint numbers that are known to be inert.) */
    asm volatile("hint #16");

    /* Nops interleaved with real work. */
    unsigned long v = 1;
    asm volatile("nop\n\t"
                 "add %0, %0, #41\n\t"
                 "yield\n\t"
                 "nop"
                 : "+r"(v)
                 :
                 : );
    ZASSERT(v == 42);
    return 0;
}
