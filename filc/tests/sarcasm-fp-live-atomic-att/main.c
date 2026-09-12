/* Mixed liveness across the atomic-pointer runtime calls: xmm0 (a double,
   8 bytes live) and xmm2 (a 16-byte movdqu pair) are live across the
   `;! atomic store ptr` runtime call (filc_store_ptr_atomic_outline — it
   can allocate, so it runs GC code that clobbers caller-saved vector
   state); xmm1 is dead across that call. The width-aware expansion must
   save exactly xmm0 (movsd) and xmm2 (movdqu) around the store call
   (verified via -S, see atomic.s). The round-tripped values are checked
   exactly under allocation churn. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdfil.h>
#include <filc_test_support.h>

#define ASSERT(exp) do { \
    if ((exp)) \
        break; \
    fprintf(stderr, "%s:%d: %s: assertion %s failed.\n", \
            __FILE__, __LINE__, __PRETTY_FUNCTION__, #exp); \
    abort(); \
} while (0)

long fp_atomic_mix(void** slot, char* buf);

int main()
{
    void** slot = malloc(2 * sizeof(void*));
    char* buf = malloc(16);
    ASSERT(slot && buf);
    uint64_t magic = 0x0123456789abcdefULL;
    memcpy(buf, &magic, 8);
    memset(buf + 8, 0, 8);
    size_t i, repeat = 30000;
    if (zgc_is_stw())
        repeat = 1000;
    for (i = 0; i < repeat; i++) {
        void* junk = malloc(64);
        memset(junk, 1, 64);
        free(junk);

        slot[1] = &buf[0];
        long got = fp_atomic_mix(slot, buf);
        /* xmm0's double (81.0) must have survived the runtime call: */
        ASSERT(got == 81);
        /* xmm2's 16 bytes must have survived: they were stored back. */
        uint64_t back;
        memcpy(&back, buf, 8);
        ASSERT(back == magic);
        /* the atomic pointer store wrote the loaded pointer into slot[0] */
        ASSERT(slot[0] == &buf[0]);
    }
    printf("fp atomic mix ok\n");
    return 0;
}
