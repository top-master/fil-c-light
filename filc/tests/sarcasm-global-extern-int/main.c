/* Intel-syntax twin of sarcasm-global-extern-att. */
#include <stdio.h>
long ext_lea(long i);
long ext_direct(void);
void ext_store(long i, long v);
extern int g[4];
int main()
{
    long s = 0;
    for (long i = 0; i < 4; i++) s += ext_lea(i);
    if (s != 1000) {
        printf("FAIL ext_lea\n");
        return 1;
    }
    if (ext_direct() != 700) {
        printf("FAIL ext_direct\n");
        return 1;
    }
    ext_store(1, 999);
    if (g[1] != 999) {
        printf("FAIL ext_store\n");
        return 1;
    }
    printf("extern int ok\n");
    return 0;
}
