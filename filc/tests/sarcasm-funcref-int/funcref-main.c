#include <stdio.h>

struct ftable {
    long (*f1)(long);
    long (*f2)(long);
};

void setup_table(struct ftable *t, long sel);

/* The extern `#! funcref` target: defined in this (C) module, so the asm side
   materializes its flight pointer through the pizlonated_c_helper getter. */
long c_helper(long x)
{
    return x * 10;
}

int main()
{
    struct ftable t;

    setup_table(&t, 0);
    if (t.f1(100) != 101) {   /* func_a: x + 1 */
        printf("FAIL sel=0: %ld\n", t.f1(100));
        return 1;
    }
    if (t.f2(5) != 50) {      /* c_helper: x * 10 */
        printf("FAIL helper: %ld\n", t.f2(5));
        return 1;
    }

    setup_table(&t, 1);
    if (t.f1(100) != 102) {   /* func_b: x + 2 */
        printf("FAIL sel=1: %ld\n", t.f1(100));
        return 1;
    }

    setup_table(&t, 2);
    if (t.f1(100) != 103) {   /* func_c: x + 3 */
        printf("FAIL sel=2: %ld\n", t.f1(100));
        return 1;
    }

    setup_table(&t, 3);       /* extern c_helper through the cmov chain */
    if (t.f1(5) != 50) {
        printf("FAIL sel=3: %ld\n", t.f1(5));
        return 1;
    }

    setup_table(&t, 99);      /* no match: keeps func_a */
    if (t.f1(100) != 101) {
        printf("FAIL sel=99: %ld\n", t.f1(100));
        return 1;
    }

    printf("funcref int ok\n");
    return 0;
}
