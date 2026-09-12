#include <stdfil.h>
#include <stdint.h>

int main(void)
{
    /* CBW: sign-extend AL to AX. */
    uint16_t in_cbw = 0x80;
    uint16_t out_cbw;
    asm volatile("cbw" : "=a"(out_cbw) : "a"(in_cbw));
    ZASSERT(out_cbw == 0xff80);

    /* CWDE: sign-extend AX to EAX. */
    uint32_t in_cwde = 0x8000;
    uint32_t out_cwde;
    asm volatile("cwde" : "=a"(out_cwde) : "a"(in_cwde));
    ZASSERT(out_cwde == 0xffff8000);

    /* CDQE: sign-extend EAX to RAX. */
    uint64_t in_cdqe = 0x80000000ull;
    uint64_t out_cdqe;
    asm volatile("cdqe" : "=a"(out_cdqe) : "a"(in_cdqe));
    ZASSERT(out_cdqe == 0xffffffff80000000ull);

    return 0;
}
