#include <stdio.h>

/* jrcxz branches when rcx==0 and has ONLY a rel8 encoding; a non-memory filler
   pushes each branch's label beyond +-127 bytes. Sarcasm rewrites every jrcxz
   through a nearby trampoline. Each site's taken (rcx==0) and not-taken
   (rcx!=0) paths are exercised across two calls, matching hardware. The
   checked loads all run before the counter is defined (the capability lower
   rides the physical rcx the jrcxz tests — see the test .s comment). Hardware
   ground truth (plain as + gcc): jrcxz_site(p,0)=29, jrcxz_site(p,1)=335544369,
   jrcxz_pair(p,0)=12, jrcxz_pair(p,1)=167772182. */
long jrcxz_site(long *p, long n), jrcxz_pair(long *p, long n);

int main()
{
    long buf[6] = {1,2,3,4,5,6};
    if (jrcxz_site(buf, 0) != 29) { printf("bad jrcxz site taken\n"); return 1; }
    if (jrcxz_site(buf, 1) != 335544369) { printf("bad jrcxz site not-taken\n"); return 1; }
    if (jrcxz_pair(buf, 0) != 12) { printf("bad jrcxz pair taken\n"); return 1; }
    if (jrcxz_pair(buf, 1) != 167772182) { printf("bad jrcxz pair not-taken\n"); return 1; }
    printf("jrcxz big att ok\n");
    return 0;
}
