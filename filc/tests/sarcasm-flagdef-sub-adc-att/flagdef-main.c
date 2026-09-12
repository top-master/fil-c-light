#include <stdio.h>
extern long flagdef_sub_adc(long a, long b);
int main(void) {
    long r1 = flagdef_sub_adc(5, 3);  /* 3 < 5  -> CF=1 -> 1 */
    long r2 = flagdef_sub_adc(3, 5);  /* 3 >= 5 -> CF=0 -> 0 */
    long r3 = flagdef_sub_adc(7, 7);  /* equal  -> CF=0 -> 0 */
    if (r1 != 1 || r2 != 0 || r3 != 0) {
        printf("FAIL: got %ld %ld %ld (want 1 0 0)\n", r1, r2, r3);
        return 1;
    }
    printf("flagdef sub adc ok\n");
    return 0;
}
