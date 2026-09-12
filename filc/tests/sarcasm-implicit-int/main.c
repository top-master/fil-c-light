#include <stdio.h>
#include <stdlib.h>
#include <string.h>

long cpuid_vendor_int(char* buf);
long rdtsc_now_int(void);
long rdtscp_now_int(unsigned* aux);
long xgetbv0_int(void);

int main(void)
{
    char* vendor = malloc(16);
    unsigned* aux = malloc(16);
    if (!vendor || !aux)
        return 1;

    /* cpuid leaf 0: max basic leaf + vendor string. */
    long maxleaf = cpuid_vendor_int(vendor);
    if (strcmp(vendor, "GenuineIntel") && strcmp(vendor, "AuthenticAMD")
        && strcmp(vendor, "HygonGenuine")) {
        printf("bad vendor string: '%s'\n", vendor);
        return 1;
    }
    if (maxleaf < 1) {
        printf("bad max basic leaf: %ld\n", maxleaf);
        return 1;
    }

    /* rdtsc: two reads, the second must not be smaller. */
    long t1 = rdtsc_now_int();
    long t2 = rdtsc_now_int();
    if (t2 < t1) {
        printf("rdtsc went backwards: %ld -> %ld\n", t1, t2);
        return 1;
    }

    /* rdtscp: same monotonicity, and TSC_AUX must be stable. */
    long t3 = rdtscp_now_int(aux);
    unsigned aux1 = *aux;
    long t4 = rdtscp_now_int(aux);
    unsigned aux2 = *aux;
    if (t4 < t3) {
        printf("rdtscp went backwards: %ld -> %ld\n", t3, t4);
        return 1;
    }
    if (aux1 != aux2) {
        printf("TSC_AUX changed: %u -> %u\n", aux1, aux2);
        return 1;
    }

    /* xgetbv(0) = XCR0: x87 (bit 0) and SSE (bit 1) are always enabled by the
       OS on any working x86-64 system. */
    long xcr0 = xgetbv0_int();
    if ((xcr0 & 3) != 3) {
        printf("XCR0=0x%lx: x87/SSE state not enabled\n", xcr0);
        return 1;
    }

    printf("implicit int ok (vendor=%s maxleaf=%ld xcr0=0x%lx)\n", vendor, maxleaf, xcr0);
    return 0;
}
