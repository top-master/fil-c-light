#include <stdio.h>
#include <stdlib.h>

void cpuid7_all(long* out);
long cpuid_stress(long* out);
long cpuid_own(long leaf);
long cpuid_heavy(void);

int main(void)
{
    long* out = malloc(64);
    long* ref = malloc(64);
    if (!out || !ref)
        return 1;
    cpuid7_all(ref);
    long refsum = ref[0] + ref[1] + ref[2] + ref[3];

    /* cpuid under pressure: six live-across webs survive; outputs exact. */
    long h = cpuid_stress(out);
    if (h != 11 + 22 + 33 + 44 + 55 + 66) {
        printf("cpuid_stress hash %ld, want %d\n", h, 11 + 22 + 33 + 44 + 55 + 66);
        return 1;
    }
    if (out[0] != ref[0] || out[1] != ref[1] || out[2] != ref[2] || out[3] != ref[3]) {
        printf("cpuid_stress outputs %ld/%ld/%ld/%ld, want %ld/%ld/%ld/%ld\n",
               out[0], out[1], out[2], out[3], ref[0], ref[1], ref[2], ref[3]);
        return 1;
    }

    /* User's own eax/ecx flow in; all four outputs flow out (coalescing). */
    long own = cpuid_own(7);
    if (own != refsum) {
        printf("cpuid_own %ld, want %ld\n", own, refsum);
        return 1;
    }

    /* Heavy pressure: eleven live-across webs spill/reload around cpuid. */
    long heavy = cpuid_heavy();
    long want_heavy = 66 + refsum;
    if (heavy != want_heavy) {
        printf("cpuid_heavy %ld, want %ld\n", heavy, want_heavy);
        return 1;
    }

    printf("implicit pin att ok\n");
    return 0;
}
