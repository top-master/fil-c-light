#include <stdfil.h>
#include <stdint.h>

int main(void)
{
    /* CWD: sign-extend AX to DX:AX. */
    uint16_t in_cwd = 0x8000;
    uint16_t out_dx_cwd;
    asm volatile("cwd" : "=d"(out_dx_cwd) : "a"(in_cwd));
    ZASSERT(out_dx_cwd == 0xffff);

    /* CDQ: sign-extend EAX to EDX:EAX. */
    uint32_t in_cdq = 0x80000000u;
    uint32_t out_edx_cdq;
    asm volatile("cdq" : "=d"(out_edx_cdq) : "a"(in_cdq));
    ZASSERT(out_edx_cdq == 0xffffffffu);

    /* CQO: sign-extend RAX to RDX:RAX. */
    uint64_t in_cqo = 0x8000000000000000ull;
    uint64_t out_rdx_cqo;
    asm volatile("cqo" : "=d"(out_rdx_cqo) : "a"(in_cqo));
    ZASSERT(out_rdx_cqo == 0xffffffffffffffffull);

    return 0;
}
