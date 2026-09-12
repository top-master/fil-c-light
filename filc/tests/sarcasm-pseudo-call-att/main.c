#include <stdio.h>

long pseudo_across_call(long a, long b);

int main(void)
{
    /* (3) + 2*5 + 5 = 18 */
    if (pseudo_across_call(3, 5) != 18) {
        printf("FAIL call\n");
        return 1;
    }
    printf("pseudo call ok\n");
    return 0;
}
