#include <stdfil.h>

int main(void)
{
    /* RNDR: the architectural random number generator (FEAT_RNG). Each
       read writes the destination register with fresh entropy, and it also
       writes PSTATE.Z (Z = 1 on entropy-source failure), so every read
       requires the "cc" clobber. */
    unsigned long v[8];
    for (int i = 0; i < 8; i++)
        asm volatile("mrs %0, rndr" : "=r"(v[i]) : : "cc");

    /* The eight reads must not all be the same value. RNDR returns the
       previous read's value when the entropy source fails, so a persistent
       failure shows up as all-equal; eight successive 64-bit collisions of
       genuine randomness are impossible in practice. */
    unsigned long distinct = 0;
    for (int i = 1; i < 8; i++)
        if (v[i] != v[0])
            ++distinct;
    ZASSERT(distinct > 0);

    /* The register name spelling in the allowlist is case-insensitive. */
    unsigned long u;
    asm volatile("mrs %0, RNDR" : "=r"(u) : : "cc");
    zprintf("rndr checksum: %lx\n", u ^ v[0]);

    /* RNDRRS: the reseeding variant reads fine too (its value is
       unobservable state, so it is only exercised, not asserted on). It
       also writes PSTATE.Z, so it needs the "cc" clobber as well. */
    unsigned long a;
    unsigned long b;
    asm volatile("mrs %0, rndrrs" : "=r"(a) : : "cc");
    asm volatile("mrs %0, rndrrs" : "=r"(b) : : "cc");
    zprintf("rndrrs checksum: %lx\n", a ^ b);

    return 0;
}
