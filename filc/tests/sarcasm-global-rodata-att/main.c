/* Same-file .rodata data object: direct rip-relative scalar loads
   (movl tab(%rip) / movl tab+4(%rip)) compile to a verbatim instruction
   plus a synthesized effective-address lea, a payload-base lea, and the
   ordinary access check. */
#include <stdio.h>
long roread(void);
long roread2(long unused);
int main()
{
    if (roread() != 100) {
        printf("FAIL roread\n");
        return 1;
    }
    if (roread2(0) != 52) {
        printf("FAIL roread2\n");
        return 1;
    }
    printf("rodata att ok\n");
    return 0;
}
