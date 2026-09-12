#include <stdio.h>
#include <stdlib.h>

void cpuid7_all_int(long* out);
long cpuid_stress_int(long* out);
long cpuid_own_int(long leaf);
long cpuid_heavy_int(void);

int main(void)
{
    long* out = malloc(64);
    long* ref = malloc(64);
    if (!out || !ref)
        return 1;
    cpuid7_all_int(ref);
    long refsum = ref[0] + ref[1] + ref[2] + ref[3];

    /* cpuid under pressure: six live-across webs survive; outputs exact. */
    long h = cpuid_stress_int(out);
    if (h != 11 + 22 + 33 + 44 + 55 + 66) {
        printf("cpuid_stress_int hash %ld, want %d\n", h, 11 + 22 + 33 + 44 + 55 + 66);
        return 1;
    }
    if (out[0] != ref[0] || out[1] != ref[1] || out[2] != ref[2] || out[3] != ref[3]) {
        printf("cpuid_stress_int outputs %ld/%ld/%ld/%ld, want %ld/%ld/%ld/%ld\n",
               out[0], out[1], out[2], out[3], ref[0], ref[1], ref[2], ref[3]);
        return 1;
    }

    /* User's own eax/ecx flow in; all four outputs flow out (coalescing). */
    long own = cpuid_own_int(7);
    if (own != refsum) {
        printf("cpuid_own_int %ld, want %ld\n", own, refsum);
        return 1;
    }

    /* Heavy pressure: eleven live-across webs spill/reload around cpuid. */
    long heavy = cpuid_heavy_int();
    long want_heavy = 66 + refsum;
    if (heavy != want_heavy) {
        printf("cpuid_heavy_int %ld, want %ld\n", heavy, want_heavy);
        return 1;
    }

    printf("implicit pin int ok\n");
    return 0;
}
