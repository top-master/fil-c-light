#include <stdio.h>

long dotalloca_arm_imm(long v);
long dotalloca_arm_reg(long size, long align, long v);
long dotalloca_arm_pseudo(long size, long align, long v);
long dotalloca_arm_slot(long size, long align, long v);

int main(void)
{
    if (dotalloca_arm_imm(3) != 3) {
        printf("FAIL imm\n");
        return 1;
    }
    if (dotalloca_arm_reg(40, 16, 5) != 5) {
        printf("FAIL reg\n");
        return 1;
    }
    if (dotalloca_arm_pseudo(40, 32, 7) != 7) {
        printf("FAIL pseudo\n");
        return 1;
    }
    if (dotalloca_arm_slot(40, 16, 9) != 9) {
        printf("FAIL slot\n");
        return 1;
    }
    printf("dotalloca arm ok\n");
    return 0;
}
