#include <stdio.h>

int c_marker;
extern int asm_marker;

void c_setup(void)
{
    c_marker = 42;
}

int main()
{
    /* Both `.section .init` calls ran before main (through
       filc_defer_or_run_global_ctor, like any Fil-C constructor). */
    if (asm_marker != 1234) {
        printf("FAIL asm_marker=%d\n", asm_marker);
        return 1;
    }
    if (c_marker != 42) {
        printf("FAIL c_marker=%d\n", c_marker);
        return 1;
    }
    printf("init att ok\n");
    return 0;
}
