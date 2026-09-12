/* The sha256 K256 shape: `leaq tab(%rip),%rB` seeds a pointer (iv = the lea,
   lo = the data object's payload base), and register-indexed accesses
   through it ride the ordinary checked path. */
#include <stdio.h>
#include <string.h>
long ktab_get(long i);
void ktab_vec(void* out, long off);
int main()
{
    unsigned want[8] = { 0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
                         0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5 };
    for (long i = 0; i < 8; i++) {
        if ((unsigned)ktab_get(i) != want[i]) {
            printf("FAIL ktab_get(%ld)\n", i);
            return 1;
        }
    }
    unsigned buf[4];
    memset(buf, 0, sizeof(buf));
    ktab_vec(buf, 16);
    if (memcmp(buf, want + 4, 16) != 0) {
        printf("FAIL ktab_vec\n");
        return 1;
    }
    printf("lea-index att ok\n");
    return 0;
}
