#include <stdio.h>

extern long foo(long x);
extern long bar(long x);

int main(void)
{
    /* foo(3): w(3)=13; w(14)=68 -> 13+68=81; w(82)=408 -> 81+408=489 */
    if (foo(3) != 489) {
        printf("FAIL foo: %ld\n", foo(3));
        return 1;
    }
    /* bar(4): w(4)=18; w(36)=178 -> 18+178=196 */
    if (bar(4) != 196) {
        printf("FAIL bar: %ld\n", bar(4));
        return 1;
    }
    printf("localcall multicaller att ok\n");
    return 0;
}
