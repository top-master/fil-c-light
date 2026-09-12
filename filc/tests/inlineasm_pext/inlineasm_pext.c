#include <stdfil.h>

static unsigned long ref_pext(unsigned long src, unsigned long mask)
{
    unsigned long result = 0;
    int k = 0;
    for (int i = 0; i < 64; i++) {
        if (mask & (1UL << i)) {
            if (src & (1UL << i))
                result |= (1UL << k);
            k++;
        }
    }
    return result;
}

int main(void)
{
    unsigned long cases[][2] = {
        {0xff, 0x0f},
        {0x00, 0xff},
        {0xdeadbeef, 0xaaaaaaaa},
        {0x12345678, 0xf0f0f0f0},
        {0xffffffffffffffffUL, 0xffffffffffffffffUL},
        {0x8000000000000000UL, 0x5555555555555555UL},
        {0x1, 0x8000000000000000UL},
        {0xdeadbeefcafebabeUL, 0x00000000000000ffUL},
    };
    for (unsigned i = 0; i < sizeof(cases) / sizeof(cases[0]); i++) {
        unsigned long src = cases[i][0];
        unsigned long mask = cases[i][1];
        unsigned long dest;
        asm volatile("pext %1, %2, %0"
                     : "=r"(dest)
                     : "r"(mask), "r"(src));
        ZASSERT(dest == ref_pext(src, mask));
    }

    return 0;
}
