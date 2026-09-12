#include <stdfil.h>

int main(void)
{
    /* Writing all of z0 (up to 512 bits of SVE state) is not covered by
       declaring only v0-v2 (128 bits each): z0-z31 get their own register
       families, so a z-register write needs a z-register clobber. */
    asm volatile("add z0.s, z1.s, z2.s" ::: "v0", "v1", "v2");
    zprintf("not reached\n");
    return 0;
}
