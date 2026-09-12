#include <stdfil.h>

int main(void)
{
    /* An i128 operand is threaded through a single (64-bit) register: the
       asm only defines the low bits of the operand and the upper bits are
       stale register garbage, which counts as legal register-value
       disclosure. (clang emits -Wasm-operand-widths warnings for this; the
       warnings are expected and do not fail the build.) */
    unsigned __int128 a = 5;
    unsigned __int128 b = 7;
    unsigned __int128 x = 1;
    asm volatile("add %0, %1, %2" : "+r"(a) : "r"(b), "r"(x));
    ZASSERT((unsigned long)a == 8);
    zprintf("i128 ok\n");
    return 0;
}
