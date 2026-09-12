#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

static __attribute__((noinline)) void* get_null(void)
{
    return 0;
}

int main(void)
{
    unsigned char* p = opaque(get_null());
    uint32x4x2_t r = vld2q_u32(p);
    ZASSERT(r.val[0][0] == 0);
    zprintf("Should have failed!\n");
    return 0;
}
