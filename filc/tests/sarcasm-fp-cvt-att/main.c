#include <stdio.h>

long cvt_ss(long n);
long cvt_sd(long n);
long cvt_ss_sd(long n);
long mov_dq(long n);
long pins_ext(long n);
long masks(long bits);

int main()
{
    printf("cvt %ld %ld %ld %ld %ld %ld\n",
           cvt_ss(7), cvt_sd(7), cvt_ss_sd(7),
           mov_dq(0xFFFFFFFFL), pins_ext(0xABCDL), masks(0x8000000080000000L));
    return 0;
}
