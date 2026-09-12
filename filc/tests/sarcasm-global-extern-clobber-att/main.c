/* The getter is an injected call (caller-saved clobbers + the fpSave/
   fpRestore vector preservation): every GPR and xmm value live across a
   `#! global ptr` materialization must survive. */
#include <stdio.h>
#include <stdint.h>
long clobber(void);
int main()
{
    uint32_t want32 = (uint32_t)(1000 + 2000) + 0x11223344u + 0x55667788u + 0x99aabbccu;
    long want = (long)want32 + 11 + 22 + 33 + 44 + 55;
    long got = clobber();
    if (got != want) {
        printf("FAIL: got %ld, want %ld\n", got, want);
        return 1;
    }
    printf("extern-clobber att ok\n");
    return 0;
}
