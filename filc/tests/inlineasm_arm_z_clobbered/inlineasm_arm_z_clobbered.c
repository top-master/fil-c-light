#include <stdfil.h>

int main(void)
{
    /* A z-register write covered by z-register clobbers is fine: the z
       families account for the full SVE vector length. This executes SVE
       instructions, so it needs hardware SVE (needsSVE in the manifest). */
    asm volatile("add z0.s, z1.s, z2.s" ::: "z0", "z1", "z2");
    zprintf("z clobber ok\n");
    return 0;
}
