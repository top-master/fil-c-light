#include <stdio.h>

extern long foo(long x);

int main(void)
{
    /* step(v) = v+3. foo(10): s1=13, s2=16; s2 >= s1 -> fall path: s3'=16;
       result = 13 + 16 + 16 = 45. */
    if (foo(10) != 45) {
        printf("FAIL: got %ld, want 45\n", foo(10));
        return 1;
    }
    printf("localcall dispatch att ok\n");
    return 0;
}
