#include <stdfil.h>

int main(void)
{
    /* DCZID_EL0: DZP (bit 0) must be clear for usable DC ZVA. */
    unsigned long dczid;
    asm volatile("mrs %0, dczid_el0" : "=r"(dczid));
    ZASSERT((dczid & 1) == 0);
    ZASSERT(dczid < 0x100);

    /* CTR_EL0: cache type register is nonzero and encodes line sizes. */
    unsigned long ctr;
    asm volatile("mrs %0, ctr_el0" : "=r"(ctr));
    ZASSERT(ctr != 0);
    ZASSERT(((ctr >> 16) & 0xF) != 0); /* DminLine */

    /* CNTFRQ_EL0: counter frequency is nonzero. */
    unsigned long freq;
    asm volatile("mrs %0, cntfrq_el0" : "=r"(freq));
    ZASSERT(freq != 0);

    /* CNTVCT_EL0: counter is monotonic. */
    unsigned long t1;
    unsigned long t2;
    asm volatile("mrs %0, cntvct_el0" : "=r"(t1));
    asm volatile("mrs %0, cntvct_el0" : "=r"(t2));
    ZASSERT(t2 >= t1);

    /* Register-variable binding style. */
    register long t0 asm("x0");
    asm volatile("mrs %0, cntvct_el0" : "=r"(t0));
    ZASSERT(t0 >= 0);

    register long fr asm("x1");
    asm volatile("mrs %0, cntfrq_el0" : "=r"(fr));
    ZASSERT(fr == (long)freq);

    /* Clobber style: read into x0, copy out. */
    unsigned long out;
    asm volatile("mrs x0, dczid_el0\n\t"
                 "mov %0, x0"
                 : "=r"(out)
                 :
                 : "x0");
    ZASSERT(out == dczid);

    /* NZCV is readable and only has the flag bits. */
    unsigned long nzcv;
    asm volatile("mrs %0, nzcv" : "=r"(nzcv));
    ZASSERT((nzcv & ~0xF0000000UL) == 0);
    return 0;
}
