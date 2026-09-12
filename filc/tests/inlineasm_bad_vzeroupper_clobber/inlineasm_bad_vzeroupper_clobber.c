#include <stdfil.h>

int main(void)
{
    /* VZEROUPPER writes ALL of YMM0-YMM15, so every one must be clobbered.
       Here only ymm0 is clobbered, which Fil-C must reject as a safety error. */
    asm volatile("vzeroupper" ::: "ymm0");
    return 0;
}
