/* Direct rip-relative vector loads: `movdqa ktab+512(%rip),%xmm7` against a
   64-byte-aligned table (the DO's leading-pad trick keeps the payload
   alignment), and vmovdqu loads against a second 64-aligned block. */
#include <stdio.h>
#include <string.h>
void vecload(void* out);
int main()
{
    unsigned char buf[64];
    memset(buf, 0, sizeof(buf));
    vecload(buf);
    unsigned want0[8] = { 1, 2, 3, 4, 5, 6, 7, 8 };
    if (memcmp(buf, want0, 32) != 0) {
        printf("FAIL ktab part\n");
        return 1;
    }
    unsigned char want1[32] = {
        1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,
        16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1 };
    if (memcmp(buf + 32, want1, 32) != 0) {
        printf("FAIL atab part\n");
        return 1;
    }
    printf("vec att ok\n");
    return 0;
}
