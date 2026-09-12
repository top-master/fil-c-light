#include <stdio.h>

/* Sum of truncated results: fadd/fsub/fmul/fdiv/fsqrt/fabs/fmadd (d),
   fadd/fmul (s), faddp reduction, integer add v.4s lane, fmla v.4s lane,
   plus the original a. (3,12): 15-9+36+0+6+15+51 +15+36 +15 +15+37 +3 = 235;
   (5,20): 25-15+100+0+10+25+125 +25+100 +25 +25+101 +5 = 551. */
long f_arith(long a, long b);

int main()
{
    printf("arith %ld %ld\n", f_arith(3, 12), f_arith(5, 20));
    return 0;
}
