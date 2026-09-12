#include <stdio.h>

extern long big_frame(long a, long b, long go);
extern long small_frame(long a);

int main(void)
{
    /* go=0: rbx = 10+4 = 14 -> tail: 14*2 + 5 = 33 */
    long r1 = big_frame(10, 4, 0);
    /* go=1: deep path: 14 + 10 = 24 */
    long r2 = big_frame(10, 4, 1);
    /* small_frame direct: 3*7 = 21 -> tail: 21*2 + 5 = 47 */
    long r3 = small_frame(7);
    if (r1 != 33 || r2 != 24 || r3 != 47) {
        printf("FAIL: got %ld %ld %ld\n", r1, r2, r3);
        return 1;
    }
    printf("sharedtail depth att ok\n");
    return 0;
}
