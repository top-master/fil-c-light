#include <stdfil.h>

int main(void)
{
    float f1 = 1.0f;
    float f2 = 2.0f;
    /* fcmp sets FP flags in FPSR, which cannot be declared as a clobber */
    asm volatile("fcmp %s0, %s1"
                 :
                 : "w"(f1), "w"(f2));
    zprintf("not reached\n");
    return 0;
}
