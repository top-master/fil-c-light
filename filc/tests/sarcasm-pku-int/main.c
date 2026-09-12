#include <stdio.h>

long cpuid_max_leaf_int(void);
long cpuid7_ecx_int(void);
long pkru_read_int(void);
void pkru_write_int(long v);

int main(void)
{
    /* PKU may be absent; probe CPUID leaf 7 sub-leaf 0 ECX for PKU (bit 3)
       and OSPKE (bit 4, the OS enabled protection keys) before touching
       rdpkru/wrpkru. */
    if (cpuid_max_leaf_int() < 7) {
        printf("pku int ok (no CPUID leaf 7; rdpkru/wrpkru skipped)\n");
        return 0;
    }
    unsigned ecx = (unsigned)cpuid7_ecx_int();
    if ((ecx & 0x18) != 0x18) {
        printf("pku int ok (PKU%s%s unsupported; rdpkru/wrpkru skipped)\n",
               (ecx & 8) ? " hardware" : "",
               (ecx & 16) ? " OSPKE" : "");
        return 0;
    }

    /* Read PKRU, write the SAME value back (a no-op write — safe: it cannot
       change any page's access rights), and read again. */
    unsigned v = (unsigned)pkru_read_int();
    pkru_write_int(v);
    unsigned v2 = (unsigned)pkru_read_int();
    if (v2 != v) {
        printf("PKRU changed across no-op wrpkru: 0x%x -> 0x%x\n", v, v2);
        return 1;
    }
    printf("pku int ok (pkru=0x%x)\n", v);
    return 0;
}
