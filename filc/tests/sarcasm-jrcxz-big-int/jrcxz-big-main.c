#include <stdio.h>

/* Intel-syntax twin of sarcasm-jrcxz-big-att: jrcxz sites with targets beyond
   rel8 range, rewritten by sarcasm through a nearby trampoline; both the taken
   (rcx==0) and not-taken paths of each site are exercised, matching hardware.
   Hardware ground truth (plain as + gcc): jrcxz_site(p,0)=29,
   jrcxz_site(p,1)=335544369, jrcxz_pair(p,0)=12, jrcxz_pair(p,1)=167772182. */
long jrcxz_site(long *p, long n), jrcxz_pair(long *p, long n);

int main()
{
    long buf[6] = {1,2,3,4,5,6};
    if (jrcxz_site(buf, 0) != 29) { printf("bad jrcxz site taken\n"); return 1; }
    if (jrcxz_site(buf, 1) != 335544369) { printf("bad jrcxz site not-taken\n"); return 1; }
    if (jrcxz_pair(buf, 0) != 12) { printf("bad jrcxz pair taken\n"); return 1; }
    if (jrcxz_pair(buf, 1) != 167772182) { printf("bad jrcxz pair not-taken\n"); return 1; }
    printf("jrcxz big int ok\n");
    return 0;
}
