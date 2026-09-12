#include <stdio.h>

extern long alias_caller(long x);
extern long triple(long x);
extern long asm_triple(long x);

int main(void)
{
    long r1 = alias_caller(14);    /* jne asm_triple -> triple: 42 */
    long r2 = alias_caller(0);     /* fallthrough: 1 */
    long r3 = triple(5);           /* C calls the real name: 15 */
    long r4 = asm_triple(9);       /* C calls the alias name: 27 */
    if (r1 != 42 || r2 != 1 || r3 != 15 || r4 != 27) {
        printf("FAIL: got %ld %ld %ld %ld\n", r1, r2, r3, r4);
        return 1;
    }
    printf("alias entry att ok\n");
    return 0;
}
