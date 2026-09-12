/* Same-file `.comm g,16,16` becomes a writable data object, exported (the
   unsafe-export alias + pizlonated_g getter). Asm stores with direct
   rip-relative movl; C reads through the emitted getter; asm loads back
   through the inline-GP seeded lea. */
#include <stdio.h>
void g_store(long v);
long g_load(long i);
extern int g[4];
int main()
{
    g_store(42);
    if (g[0] != 42 || g[1] != 42 || g[2] != 42 || g[3] != 42) {
        printf("FAIL C-side read\n");
        return 1;
    }
    if (g_load(0) + g_load(1) + g_load(2) + g_load(3) != 168) {
        printf("FAIL asm read\n");
        return 1;
    }
    printf("comm-rw att ok\n");
    return 0;
}
