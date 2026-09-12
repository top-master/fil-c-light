#include <stdfil.h>

int main(void)
{
    /* Unlike arm32, AArch64 assembly does not treat '@' as a comment
       character: the assembler rejects the trailing junk. (The inline asm
       validator does strip '@' comments, so this fails at assembly time
       rather than with a filc safety error.) */
    asm volatile("add x0, x1, x2 @ junk" ::: "x0", "x1", "x2");
    zprintf("not reached\n");
    return 0;
}
